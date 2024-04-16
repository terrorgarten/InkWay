//
//  UserDefaultsRepository.swift
//  InkWay
//
//  Created by Oliver Bajus on 15.04.2024.
//

import Foundation

protocol UserDefaultsRepository {
    func uploadDesign(with input: DesignModel) async throws -> Void
}
