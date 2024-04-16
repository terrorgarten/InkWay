//
//  RegisterUserView.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import SwiftUI



// Present the registration form
struct RegisterUserView: View {
    
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                LoginHeadingView(title: "InkWay", subtitle: "nice to meet you!")
                    .offset(y: -50)
                Spacer()
                if viewModel.errorMessage != "" {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color.red)
                }
                Form {
                    Section("Registration"){
                        TextField("Name", text: $viewModel.name)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                            .foregroundColor(Color.mint)
                        TextField("Surename", text: $viewModel.surename)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                            .foregroundColor(Color.mint)
                        TextField("Email", text: $viewModel.email)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .foregroundColor(Color.mint)
                        SecureField("Password", text: $viewModel.password)
                            .autocapitalization(.none)
                            .foregroundColor(Color.mint)
                        SecureField("Repeat password", text: $viewModel.passwordConfirm)
                            .autocapitalization(.none)
                            .foregroundColor(Color.mint)
                        IWButton(title: "Register", action: viewModel.register)
                    }
                }
            }
        }
        .navigationBarTitle(Text("Login"), displayMode: .inline)
    }
    
}
