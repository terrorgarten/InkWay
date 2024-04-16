//
//  CreateAccountView.swift
//  InkWay
//
//  Created by terrorgarten on 14.03.2024.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct CreateAccountView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isTermsAccepted: Bool = false
    @State private var errorMessage: String? = nil

    // Placeholder
    func registerAction() {
        print("Register action triggered!")
    }
    // Placeholder
    func showTermsAndConditions() {
        print("Terms and conditions triggered!")
    }
    // Placeholder
    func signIn() {
        print("Sign in triggered!")
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Header
                Text("Create an account")
                    .font(.title)
                    .fontWeight(.bold)
                
                IWErrorMessageBar(message: errorMessage)
                
                // Register account form
                IWFormInputField(placeholder: "Enter your email", value: $email, label: "Email", color: .accentColor)
                
                IWFormInputField(placeholder: "Enter your password", value: $password, label: "Password", isSecure: true, color: .accentColor)
                
                IWFormInputField(placeholder: "Confirm your password", value: $confirmPassword, label: "Confirm Password", isSecure: true, color: .accentColor)
                
                HStack {
                    IWCheckBox(isChecked: $isTermsAccepted)
                        .padding(.trailing, 5)

                    Text("I agree to the")
                    Button(action: {
                        // Handle Terms & Conditions tap here
                        print("Terms & Conditions tapped")
                    }) {
                        Text("Terms & Conditions")
                            .fontWeight(.semibold)
                    }
                }.padding(.bottom, -14)

                IWPrimaryButton(title: "Let's go!", color: Color.accentColor, action: registerAction)
                
                HStack {
                    Text("Already have an account?")
                    Button(action: {
                        signIn()
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
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
