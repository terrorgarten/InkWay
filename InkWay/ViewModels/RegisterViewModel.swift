//
//  RegisterViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var surename: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    init() {
        // 2do
    }
    
    func register() {
        print("Register called.")
    }
}
