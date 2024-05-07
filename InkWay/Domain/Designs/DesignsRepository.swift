//
//  DesignsRepository.swift
//  InkWay
//
//  Created by Oliver Bajus on 10.03.2024.
//

import Foundation
import UIKit
import FirebaseStorage

// TODO - just example
protocol DesignsRepository {
    func uploadDesign(with input: UploadDesignUseCase.Params) async throws -> DesignModel
    func getAllDesigns() async throws -> [DesignModel]
    func getMineDesigns() async throws -> [DesignModel]
    func getUserDesigns(userId: String) async throws -> [DesignModel]
    func updateDesign(designModel: DesignModel) async throws -> DesignModel
    func createDesignStorageReference(uuid: String) -> StorageReference
}
