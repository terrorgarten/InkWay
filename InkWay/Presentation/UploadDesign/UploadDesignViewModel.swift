//
//  UploadDesignViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 31.05.2023.
//

import Foundation
import SwiftUI
import PhotosUI

enum ImageState {
    case empty
    case loading(Progress)
    case success(UIImage)
    case failure(Error)
}

class UploadDesignViewModel: ObservableObject {
    @Published var designImage: UIImage?
    @Published var designDescription: String = ""
    @Published var designName: String = ""
    @Published var designPrice: Int = 0
    @Published var designTagsSelection: [Tag] = []
    
    @Published private(set) var imageState: ImageState = .empty
    @Published var uploadError: Error?
    @Published var isUploading: Bool = false
    @Published var designUploaded: Bool = false
    @Published var designError: String? = nil

    var uploadedPost: PostModel? = nil
    
    private let designRepository: DesignsRepository
    private let uploadDesignUseCase: UploadDesignUseCase
    private let createDesignStorageReferenceUseCase: CreateDesignStorageReferenceUseCase
    private let fetchUserWithIdUseCase: FetchUserWithIdUseCase
    
    init() {
        designRepository = DesignRepositoryImpl()
        uploadDesignUseCase = UploadDesignUseCase(designsRepository: designRepository)
        createDesignStorageReferenceUseCase = CreateDesignStorageReferenceUseCase(designsRepository: designRepository)
        fetchUserWithIdUseCase = FetchUserWithIdUseCase(userRepository: UserRepositoryImpl())
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
            isUploading = true
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                return
            }
            let designUUID = UUID()
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
                self.isUploading = false
            }
        default:
            designUploaded = false
            designError = "Image cant be empty"
        }

    }
    
    func saveUserRelation(designUUID: UUID, designURL: String) async {
        do {
            let designModel = try await uploadDesignUseCase.execute(with: .init(id: designUUID, imageUrl: designURL, description: designDescription, tags: designTagsSelection.map{$0.text}, name: designName, price: designPrice))
            let user = try await fetchUserWithIdUseCase.execute(with: designModel.userId)
            uploadedPost = PostModel(design: designModel, artist: user)
            await MainActor.run {
                clearInputs()
                designUploaded = true
            }
        } catch(let err) {
            await MainActor.run {
                uploadError = err
                designUploaded = false
            }
        }
    }
    
    func clearInputs() {
        designDescription = ""
        designTagsSelection = []
        designName = ""
        designPrice = 0
        imageState = .empty
    }
}
