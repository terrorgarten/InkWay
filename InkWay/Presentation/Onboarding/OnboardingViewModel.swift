//
//  OnboardingViewModel.swift
//  InkWay
//
//  Created by Oliver Bajus on 15.04.2024.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var navigateToPath: Destination? = nil
    
    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "showedOnboarding")
        navigateToPath = .home
    }
}
