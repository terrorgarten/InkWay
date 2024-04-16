//
//  Router.swift
//  InkWay
//
//  Created by Oliver Bajus on 15.04.2024.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case home
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
