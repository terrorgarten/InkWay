//
//  LoginHeadingView.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import SwiftUI

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
                // overflow the screen
        .frame(width: UIScreen.main.bounds.width, height: 350)
        .offset(y: -75)
    }
}

struct LoginHeadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoginHeadingView(title: "Title", subtitle: "Subtitle test test test test test  test test testtesttesttesttesttesttesttesttesttesttesttesttest")
    }
}
