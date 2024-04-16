//
//  IWOnboardingSlide.swift
//  InkWay
//
//  Created by terrorgarten on 15.03.2024.
//

import SwiftUI

struct IWOnboardingSlide: View {
    var slideData: SlideData

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: slideData.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            
            Text(slideData.heading)
                .font(.title)
                .fontWeight(.bold)
            
            Text(slideData.description)
                .font(.body)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
        .foregroundColor(.white)
    }
}

struct SlideData: Hashable {
    var heading: String
    var description: String
    var imageName: String
    var backgroundColor: Color
}
