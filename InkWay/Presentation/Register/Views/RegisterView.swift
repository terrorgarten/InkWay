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
        UIApplication.shared.open(URL(string: "https://www.termsfeed.com/live/09ee5043-4803-4567-b8d9-6a14d56019e5")!)
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
                        showTermsAndConditions()
                    }) {
                        Text("Terms & Conditions")
                            .fontWeight(.semibold)
                    }
                }.padding(.bottom, -14)

                IWPrimaryButton(title: String(localized: "Let's go!"), color: Color.accentColor, action: viewModel.register)
                
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
                    IWGoogleSignInButton(action: {})
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

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
