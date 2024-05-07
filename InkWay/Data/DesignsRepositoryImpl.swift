//
//  DesignsRepositoryImpl.swift
//  InkWay
//
//  Created by Oliver Bajus on 06.05.2024.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class DesignRepositoryImpl: DesignsRepository {
    private let storage = Storage.storage()
    private let storageReference = Storage.storage().reference()
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    func uploadDesign(with input: UploadDesignUseCase.Params) async throws -> DesignModel {
        guard let userId = auth.currentUser?.uid else {
            throw DesignRepositoryError.failedToLoadCurrentUser
        }
        
        let uploadedDesign = DesignModel(
            designId: input.id,
            designURL: input.imageUrl,
            userId: userId,
            description: input.description,
            tags: input.tags,
            name: input.name,
            price: input.price
        )
        
        do {
            try await  db.collection("designs")
                .document(uploadedDesign.id.uuidString)
                .setData(uploadedDesign.asDictionary())
        }
        catch(let error) {
            print(error.localizedDescription)
            throw DesignRepositoryError.designUploadingFailed
        }
       
        return uploadedDesign
    }
    
    func getAllDesigns() async throws -> [DesignModel] {
        do {
            let snapshot = try await db.collection("designs").getDocuments()
            let designs = snapshot.documents.compactMap { queryDocumentSnapshot -> DesignModel? in
                return try? queryDocumentSnapshot.data(as: DesignModel.self)
            }
            return designs
        }
        catch(let error) {
            print(error.localizedDescription)
            throw DesignRepositoryError.failedToGetAllDesigns
        }
    }
    
    func getMineDesigns() async throws -> [DesignModel] {
        guard let userId = auth.currentUser?.uid else {
            throw DesignRepositoryError.failedToLoadCurrentUser
        }
        return try await getUserDesigns(userId: userId)
    }
    
    func getUserDesigns(userId: String) async throws -> [DesignModel] {
        do {
            let snapshot = try await db.collection("designs").whereField("userId", isEqualTo: userId).getDocuments()
            let designs = snapshot.documents.compactMap { queryDocumentSnapshot -> DesignModel? in
                return try? queryDocumentSnapshot.data(as: DesignModel.self)
            }
            return designs
        }
        catch(let error) {
            print(error.localizedDescription)
            throw DesignRepositoryError.failedToGetMineDesigns
        }
    }
    
    func updateDesign(designModel: DesignModel) async throws -> DesignModel {
        do {
            let designRef = db.collection("designs").document(designModel.id.uuidString)
            try await designRef.updateData([
                "name": designModel.name,
                "designURL": designModel.designURL,
                "tags": designModel.tags,
                "description": designModel.description,
                "price": designModel.price
            ])
            return designModel
        }
        catch(let error) {
            print(error.localizedDescription)
            throw DesignRepositoryError.failedToUpdateDesign
        }
    }
    
    func createDesignStorageReference(uuid: String) -> StorageReference {
        return storageReference.child("designs/\(uuid).jpg")
    }
}

enum DesignRepositoryError: Error {
    case designUploadingFailed
    case failedToGetAllDesigns
    case failedToLoadCurrentUser
    case failedToGetMineDesigns
    case failedToUpdateDesign
}
