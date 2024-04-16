//
//  WelcomeViewModel.swift
//  InkWay
//
//  Created by Oliver Bajus on 15.04.2024.
//

import Foundation

class WelcomeViewModel: ObservableObject {
    @Published var navigateToPath: Destination? = nil
    
    func navigateToRegistration(createTattooerProfile: Bool) {
        UserDefaults.standard.set(createTattooerProfile, forKey: "createTattooerProfile")
        navigateToPath = .register
    }
}
