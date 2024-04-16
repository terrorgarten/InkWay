//
//  DesignsRepository.swift
//  InkWay
//
//  Created by Oliver Bajus on 10.03.2024.
//

import Foundation

// TODO - just example
protocol DesignsRepository {
    func uploadDesign(with input: DesignModel) async throws -> Void
}
