//
//  IWButton.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import SwiftUI

// just a button for login/registration
struct IWButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                Text(title)
                    .foregroundColor(Color.black)
                    .bold()
            }
        }
        .foregroundColor(Color.mint)
        .padding()
    }
    
}
