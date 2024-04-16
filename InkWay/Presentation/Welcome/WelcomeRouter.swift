//
//  WelcomeRouter.swift
//  InkWay
//
//  Created by Oliver Bajus on 15.04.2024.
//

import Foundation

class WelcomeRouter: BaseRouter {
    public enum Destination: Codable, Hashable {
        case login
        case register
    }
    
    func navigateToLogin() {
        navigate(to: .profile)
    }
       
    func navigateToRegister() {
        navigate(to: .reg)
    }
}

