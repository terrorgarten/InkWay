//
//  IWAppleSignInButton.swift
//  InkWay
//
//  Created by terrorgarten on 16.03.2024.
//

import SwiftUI
import AuthenticationServices

struct IWAppleSignInButton: View {
    var onSignInCompleted: (Result<ASAuthorization, Error>) -> Void

    var body: some View {
        SignInWithAppleButton(.continue) { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            onSignInCompleted(result)
        }
        .signInWithAppleButtonStyle(.black)
        .frame(height: 50)
        .overlay(
                    RoundedRectangle(cornerRadius: 8) // Adjust the cornerRadius to match the SignInWithAppleButton's corner radius
                        .stroke(Color.white, lineWidth: 2) // Set the border color to white and adjust the lineWidth as needed
                )
    }
}

struct IWAppleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        IWAppleSignInButton(onSignInCompleted: {_ in })
            .padding()
    }
}
