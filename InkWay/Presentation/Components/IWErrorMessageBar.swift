//
//  ErrorMessage.swift
//  InkWay
//
//  Created by terrorgarten on 15.03.2024.
//

import SwiftUI

struct IWErrorMessageBar: View {
    var message: String?

    var body: some View {
        Group {
            if let message = message {
                Text(message)
                    .fontWeight(.medium)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(Color.red)
                    .cornerRadius(10)
                    .background(Color.red.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.red, lineWidth: 1)
                    )
                    .padding(.horizontal)
            }
        }
    }
}

struct ErrorMessageBar_Previews: PreviewProvider {
    static var previews: some View {
        IWErrorMessageBar(message: "An error occurred. Please try again.")
    }
}
