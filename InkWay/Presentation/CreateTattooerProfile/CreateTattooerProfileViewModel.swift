//
//  CreateTattooerProfileViewModel.swift
//  InkWay
//
//  Created by Oliver Bajus on 15.04.2024.
//

import Foundation

class CreateTattooerProfileViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var bio: String = ""
    @Published var profilePictureURL: URL? = nil
    @Published var errorMessage: String? = nil
    
    func createAccount() {
    }
}
