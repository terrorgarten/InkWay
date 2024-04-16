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


// disclaimer: generic approach, taken from the internet
class UploadDesignViewModel: ObservableObject {
    
    @Published var designImage: UIImage?
    @Published var isUploading = false
    @Published var uploadProgress: Double = 0.0
    @Published var uploadError: Error?
    @Published var designUploaded: Bool = false
    
    private let storage = Storage.storage()
    private let storageReference = Storage.storage().reference()
    
    
    
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
        
        let uploadedDesign = DesignModel(designId: designUUID, designURL: designURL, userId: userId)
        
        let db = Firestore.firestore()
        db.collection("designs")
            .document(uploadedDesign.id.uuidString)
            .setData(uploadedDesign.asDictionary())
    }
    
}
