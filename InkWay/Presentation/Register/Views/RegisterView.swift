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
                IWFormInputField(placeholder: "Enter your email", value: $viewModel.email, label: "Email", color: .accentColor)
                
                IWFormInputField(placeholder: "Enter your password", value: $viewModel.password, label: "Password", isSecure: true, color: .accentColor)
                
                IWFormInputField(placeholder: "Confirm your password", value: $viewModel.passwordConfirm, label: "Confirm Password", isSecure: true, color: .accentColor)
                
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

                IWPrimaryButton(title: "Let's go!", color: Color.accentColor, action: viewModel.register)
                
                HStack {
                    Text("Already have an account?")
                    Button(action: {
                        router.navigateToRoot()
                        router.navigate(to: .login)
                    }) {
                        Text("Sign in")
                            .fontWeight(.semibold)
                    }
                }.padding(-12)
                
                // OAuth section
                OrDivider().padding(.top, 8)
                VStack{
                    IWAppleSignInButton(onSignInCompleted: { _ in })
                        .padding(.horizontal, 85)
                        .padding(.bottom, 10)
                    IWGoogleSignInButton(action: {})
                }
            }
        }
        .onChange(of: viewModel.navigateToPath) {
            if let destination = viewModel.navigateToPath {
                viewModel.navigateToPath = nil
                router.navigate(to: destination)
            }
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
