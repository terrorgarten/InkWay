//
//  UseCase.swift
//  InkWay
//
//  Created by Oliver Bajus on 10.03.2024.
//

import Foundation

protocol UseCase {
    associatedtype Input
    associatedtype Output
    
    func execute(with input: Input) async throws -> Output
}

struct None {}
