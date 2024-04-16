//
//  IWGoogleSignInButton.swift
//  InkWay
//
//  Created by terrorgarten on 16.03.2024.
//

import SwiftUI

struct IWGoogleSignInButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image("GoogleSignInButton")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 50)
        }
    }
}

struct IWGoogleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        IWGoogleSignInButton(action: {})
    }
}
