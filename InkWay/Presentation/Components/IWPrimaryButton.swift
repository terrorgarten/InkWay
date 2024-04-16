//
//  IWPrimaryButtonView.swift
//  InkWay
//
//  Created by terrorgarten on 14.03.2024.
//

import SwiftUI

struct IWPrimaryButton: View {
    var title: String
    var color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
        }
    }
}

struct PrimaryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            IWPrimaryButton(title: "PrimaryButtonPreview", color: Color.accentColor) {
                print("Primary button tapped!")
            }
            IWPrimaryButton(title: "PrimaryButtonPreview", color: Color("SecondaryColor")) {
                print("Primary button tapped!")
            }
        }
    }
}
