//
//  IWButton.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import SwiftUI

struct IWButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    //.foregroundColor(Color.gray)
                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
            }
        }
        .padding()
    }
}

struct IWButton_Previews: PreviewProvider {
    static var previews: some View {
        IWButton(title: "Sample titile") {
            // call something
        }
    }
}
