//
//  LoginView.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // header
                LoginHeadingView(title: "InkWay", subtitle: "...ready for your next tattoo?")
                    .offset(y: -100)
                // space it up
                Spacer()
                
                // show errors from the viewModel
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color.pink)
                }
                
                // main login form
                Form {
                    Section("Enter your credentials"){
                        TextField("Your email", text: $viewModel.email)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                        SecureField("Your password", text: $viewModel.password)
                        IWButton(title: "Log me in!", action: viewModel.login)
                    }
                }
                // create acc
                VStack {
                    Text("Need new account?")
                    NavigationLink("Create one here!", destination: RegisterUserView())
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
