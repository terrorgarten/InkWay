//
//  EditDesignViewModel.swift
//  InkWay
//
//  Created by Oliver Bajus on 07.05.2024.
//

import Foundation
import SwiftUI
import PhotosUI

class EditDesignViewModel: ObservableObject {
    @Published var navigateToPath: Destination? = nil
    @Published private(set) var imageState: ImageState = .empty
    
    @Published var designImage: UIImage?
    @Published var designDescription: String = ""
    @Published var designName: String = ""
    @Published var designPrice: Int = 0
    @Published var designTagsSelection: [Tag] = []
    
    
    @Published var uploadError: Error?
    @Published var isLoading: Bool = false
    @Published var designUploaded: Bool = false
    @Published var designError: String? = nil
    @Published var updatedDesign: DesignModel? = nil
    
    let postModel: PostModel
    private let designModel: DesignModel
    
    private let designRepository: DesignsRepository
    private let updateDesignUseCase: UpdateDesignUseCase
    private let createDesignStorageReferenceUseCase: CreateDesignStorageReferenceUseCase
    
    init(postModel: PostModel) {
        self.postModel = postModel
        self.designModel = postModel.design
        designRepository = DesignRepositoryImpl()
        updateDesignUseCase = UpdateDesignUseCase(designsRepository: designRepository)
        createDesignStorageReferenceUseCase = CreateDesignStorageReferenceUseCase(designsRepository: designRepository)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct DesignImage: Transferable {
        let image: UIImage
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                return DesignImage(image: uiImage)
            }
        }
    }
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: DesignImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    func uploadDesign() {
        designError = nil
        if designName.count < 5 {
            designError = "Name needs to have at least 5 characters"
            designUploaded = false
            return
        }
        
        switch imageState {
        case .success(let image):
            isLoading = true
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                return
            }
            let designUUID = designModel.id
            let designImageRef = createDesignStorageReferenceUseCase.execute(with: designUUID.uuidString)
            
            let uploadTask = designImageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    self.uploadError = error
                    return
                }
                designImageRef.downloadURL { url, error in
                    if let error = error {
                        self.uploadError = error
                        return
                    }
                    if let cleanUrl = url {
                        Task {
                            await self.saveUserRelation(designUUID: designUUID, designURL: cleanUrl.absoluteString)
                        }
                    }
                }
            }
            uploadTask.observe(.success) { _ in
                self.isLoading = false
            }
        default:
            designUploaded = false
            designError = "Image cant be empty"
        }

    }
    
    func saveUserRelation(designUUID: UUID, designURL: String) async {
        do {
            let newDesign: DesignModel = .init(designId: designUUID, designURL: designURL, userId: designModel.userId, description: designDescription, tags: designTagsSelection.map{$0.text}, name: designName, price: designPrice)
            updatedDesign = newDesign
            let _ = try await updateDesignUseCase.execute(with: newDesign)
            await MainActor.run {
                designUploaded = true
            }
        } catch(let err) {
            uploadError = err
            designUploaded = false
        }
    }

    func loadDesign() {
        isLoading = true
        Task {
            if let data = try? Data(contentsOf: URL(string: designModel.designURL)!) {
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        imageState = .success(image)
                        designImage = image
                        designName = designModel.name
                        designDescription = designModel.description
                        designPrice = designModel.price
                        designTagsSelection = designModel.tags.map({ text in
                            Tag(text: text)
                        })
                        isLoading = false
                    }
                } else {
                    isLoading = false
                }
            } else {
                isLoading = false
            }
        }
    
    }
}

