//
//  IWSecondaryButtonView.swift
//  InkWay
//
//  Created by terrorgarten on 14.03.2024.
//

import SwiftUI

struct IWSecondaryButton: View {
    
    var title: String
    var color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(color)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(color, lineWidth: 2)
                )
                .padding(.horizontal)
        }
    }
}

struct SecondaryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            IWSecondaryButton(title: "SecondaryButtonPreview", color: Color.accentColor) {
                print("Secondary button tapped!")
            }
            
            IWSecondaryButton(title: "SecondaryButtonPreview", color: Color("SecondaryColor")) {
                print("Secondary button tapped!")
            }
        }
    }
}
