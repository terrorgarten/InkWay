//
//  LoginHeadingView.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import SwiftUI


// only shows the graphics for login header
struct LoginHeadingView: View {
    
    let title: String
    let subtitle: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(Color.gray)
            VStack {
                Text(title)
                    .font(.system(size: 48))
                    .foregroundColor(Color.black)
                    .bold()
                Text(subtitle)
                    .font(.system(size: 24))
                    .foregroundColor(Color.mint)
                    .italic()
            }
            .padding()
            
        }
        .frame(width: UIScreen.main.bounds.width, height: 150)
    }
    
}
