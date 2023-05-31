//
//  RegisterUserView.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import SwiftUI

struct RegisterUserView: View {
    
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
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
                    TextField("Surename", text: $viewModel.surename)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                    TextField("Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $viewModel.password)
                        .autocapitalization(.none)
                    SecureField("Repeat password", text: $viewModel.passwordConfirm)
                        .autocapitalization(.none)
                    IWButton(title: "Register", action: viewModel.register)
                }
            }
        }
    }
}

struct RegisterUserView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterUserView()
    }
}
