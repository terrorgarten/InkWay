//
//  DesignsRepository.swift
//  InkWay
//
//  Created by Oliver Bajus on 10.03.2024.
//

import Foundation
import UIKit

// TODO - just example
protocol DesignsRepository {
    func uploadDesign(with input: UploadDesignUseCase.Params) async throws -> None
    func getAllDesigns() async throws -> [DesignModel]
    func getMineDesigns() async throws -> [DesignModel]
    func getUserDesigns(userId: String) async throws -> [DesignModel]
}
