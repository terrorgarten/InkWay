//
//  UploadDesignViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 31.05.2023.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftUI
import PhotosUI


// disclaimer: generic approach, taken from the internet
class UploadDesignViewModel: ObservableObject {
    @Published var navigateToPath: Destination? = nil
    @Published var designImage: UIImage?
    @Published var description: String = ""
    @Published var tagsSelection: [Tag] = []
    @Published var uploadError: Error?
    @Published var isUploading: Bool = false
    @Published var uploadProgress: Double = 0.0
    @Published var designUploaded: Bool = false

    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct DesignImage: Transferable {
        let image: Image
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return DesignImage(image: image)
            }
        }
    }
    
    @Published private(set) var imageState: ImageState = .empty
    private let storage = Storage.storage()
    private let storageReference = Storage.storage().reference()
    
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
    
    // decodes and stores the image in Firebase Storage in the designs/
    // use the observe aproach
    func uploadDesignImage() {
        guard let designImage = designImage,
              let imageData = designImage.jpegData(compressionQuality: 0.8) else {
            return
        }
        let designUUID = UUID()
        let designImageRef = storageReference.child("designs/\(designUUID.uuidString).jpg")
        let uploadTask = designImageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                self.uploadError = error
                return
            }
            // url path from the Storage
            designImageRef.downloadURL { url, error in
                if let error = error {
                    self.uploadError = error
                    return
                }
                // save the record about image to db
                if let cleanUrl = url {
                    self.saveUserRelation(designUUID: designUUID, designURL: cleanUrl)
                    DispatchQueue.main.async {
                        self.designUploaded = true
                    }
                }
            }
        }
        // loading
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            self.uploadProgress = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
        }
        
        uploadTask.observe(.success) { _ in
            self.isUploading = false
        }
        
        isUploading = true
    }
    
    // saves the record about user-design relation
    func saveUserRelation(designUUID: UUID, designURL: URL){
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let uploadedDesign = DesignModel(designId: designUUID, designURL: designURL, userId: userId, description: description, tags: tagsSelection.map{$0.text})
        
        let db = Firestore.firestore()
        db.collection("designs")
            .document(uploadedDesign.id.uuidString)
            .setData(uploadedDesign.asDictionary())
    }
    
    func navigateToHome() {
        navigateToPath = .home
    }
}
