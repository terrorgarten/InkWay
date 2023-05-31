//
//  LoginView.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import SwiftUI

// present the login screen
struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                LoginHeadingView(title: "InkWay", subtitle: "...ready for your next tattoo?")
                    .offset(y: -100)
                Spacer()
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color.pink)
                }
                
                Form {
                    Section("Enter your credentials"){
                        TextField("Your email", text: $viewModel.email)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                            .foregroundColor(Color.mint)
                        SecureField("Your password", text: $viewModel.password)
                        IWButton(title: "Log me in!", action: viewModel.login)
                    }
                }
                VStack {
                    Text("Need new account?")
                        .foregroundColor(Color.mint)
                    NavigationLink("Create one here!", destination: RegisterUserView())
                        .foregroundColor(Color.mint)
                }
            }
        }
    }
    
}
