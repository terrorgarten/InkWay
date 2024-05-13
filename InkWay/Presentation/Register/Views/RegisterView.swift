//
//  CreateAccountView.swift
//  InkWay
//
//  Created by terrorgarten on 14.03.2024.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel = RegisterViewModel()
    @EnvironmentObject var router: BaseRouter

    // Placeholder
    func showTermsAndConditions() {
        print("Terms and conditions triggered!")
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Header
                Text("Create an account")
                    .font(.title)
                    .fontWeight(.bold)
                
                IWErrorMessageBar(message: viewModel.errorMessage)
                
                // Register account form
                IWFormInputField(placeholder: String(localized: "Enter your email"), value: $viewModel.email, label: String(localized: "Email"), color: .accentColor)
                
                IWFormInputField(placeholder: String(localized: "Enter your password"), value: $viewModel.password, label: String(localized: "Password"), isSecure: true, color: .accentColor)
                
                IWFormInputField(placeholder: String(localized: "Confirm your password"), value: $viewModel.passwordConfirm, label: String(localized: "Confirm Password"), isSecure: true, color: .accentColor)
                
                HStack {
                    IWCheckBox(isChecked: $viewModel.isTermsAccepted)
                        .padding(.trailing, 5)

                    Text("I agree to the")
                    Button(action: {
                        // TODO - Handle Terms & Conditions tap here
                        print("Terms & Conditions tapped")
                    }) {
                        Text("Terms & Conditions")
                            .fontWeight(.semibold)
                    }
                }.padding(.bottom, -14)

                IWPrimaryButton(title: String(localized: "Let's go!"), color: Color.accentColor, action: viewModel.registerWithEmail)
                
                
                
                // OAuth section
                OrDivider().padding(.top, -16)
                VStack{
                    IWGoogleSignInButton(action: viewModel.signInWithGoogle)
                    

                    IWAppleSignInButton(onSignInRequest: { request in
                        // Configure request here
                    }, onSignInCompleted: { (result: Result<ASAuthorization, Error>) in
                        switch result {
                        case .success(let auth):
                            // Extract token and nonce and call
                            viewModel.signInWithApple(IDToken: "extracted_IDToken", rawNonce: "nonce_used", fullName: auth.credential.fullName)
                        case .failure(let error):
                            viewModel.errorMessage = "Apple Sign In failed: \(error.localizedDescription)"
                        }
                    })
                        .frame(width: 228, height: 44)
                        .padding(.vertical, 10)
                }
                
                HStack {
                    Text("Already have an account?")
                    Button(action: {
                        router.navigateToRoot()
                        router.navigate(to: .login)
                    }) {
                        Text("Sign in")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .onChange(of: viewModel.navigateToPath) { _ in
            if let destination = viewModel.navigateToPath {
                viewModel.navigateToPath = nil
                router.navigate(to: destination)
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
