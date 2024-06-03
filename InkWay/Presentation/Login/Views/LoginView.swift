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
                
                IWFormInputField(placeholder: String(localized: "Enter your email"), value: $viewModel.email, label: String(localized: "Email"), color: .accentColor)
                
                IWFormInputField(placeholder: String(localized: "Enter your password"), value: $viewModel.password, label: String(localized: "Password"), isSecure: true, color: .accentColor)
                
                
                IWPrimaryButton(title: String(localized: "Sign In"), color: Color.accentColor, action: viewModel.login)
                
                OrDivider()
                
                VStack {
                    IWGoogleSignInButton(action: viewModel.signInWithGoogle) 
                    IWAppleSignInButton(onSignInRequest: viewModel.signInWithAppleRequest,
                                        onSignInCompleted: viewModel.signInWithAppleCompletion)
                        .padding(.horizontal, 71)
                        .padding(.vertical, 5)
                }
                
                Group{
                    Spacer()
                    Spacer()
                }
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
        .onChange(of : viewModel.navigateToPath) { _ in
            if let path = viewModel.navigateToPath {
                router.navigate(to: path)
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
