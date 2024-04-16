//
//  Router.swift
//  InkWay
//
//  Created by Oliver Bajus on 15.04.2024.
//

import Foundation
import SwiftUI

enum Destination: Hashable {
    case login
    case register
    case createTattooerProfile
    case welcome
    case onboarding
    case home
    case none
}

class BaseRouter: ObservableObject {
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        if destination == .home {
            navigateToRoot()
        } else {
            navPath.append(destination)
        }
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
