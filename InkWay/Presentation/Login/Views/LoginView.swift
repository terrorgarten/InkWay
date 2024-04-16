//
//  UserLoginView.swift
//  InkWay
//
//  Created by terrorgarten on 15.03.2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
    @EnvironmentObject var router: BaseRouter
    
    // Placeholder
    func signInAction() {
        viewModel.login()
    }
    
    // Placeholder
    func navigateToRegistration() {
        router.navigate(to: .register)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                ZStack{
                    Text("Welcome back!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.vertical)
                }                
                IWErrorMessageBar(message: viewModel.errorMessage)
                
                IWFormInputField(placeholder: "Enter your email", value: $viewModel.email, label: "Email", color: .accentColor)
                
                IWFormInputField(placeholder: "Enter your password", value: $viewModel.password, label: "Password", isSecure: true, color: .accentColor)
                
                
                IWPrimaryButton(title: "Sign In", color: Color.accentColor, action: signInAction)
                
                OrDivider()
                
                VStack {
                    IWGoogleSignInButton(action: {}) // Add action
                    IWAppleSignInButton(onSignInCompleted: { _ in })
                        .padding(.horizontal, 50)
                }
                

                Spacer()
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                    Button(action: {
                        router.navigateToRoot()
                        navigateToRegistration()
                    }) {
                        Text("Register")
                            .fontWeight(.semibold)
                    }
                }
                
                Button(action: {
                    // TODO - create forgot password flow
                    router.navigateToRoot()
                    navigateToRegistration()
                }) {
                    Text("Forgot password?")
                        .fontWeight(.semibold)
                }
            }
            .padding()
        }
        .onChange(of: viewModel.navigateToPath) {
            if let destination = viewModel.navigateToPath {
                viewModel.navigateToPath = nil
                router.navigate(to: destination)
            }
        }
    }
}

struct OrDivider: View {
    var body: some View {
        HStack {
            line
            Text("or")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal, 8)
            line
        }
    }
    
    var line: some View {
        VStack { Divider() }.background(Color.gray)
    }
}


struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
