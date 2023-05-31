//
//  UserLocationRequestView.swift
//  InkWay
//
//  Created by terrorgarten on 29.05.2023.
//

import SwiftUI

struct UserLocationRequestView: View {
    var body: some View {
        ZStack {
            Color(.systemBlue).ignoresSafeArea()
            
            VStack {
                Spacer()
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 32)
                
                Text("Share loc?")
                    .font(.system(size: 28, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Share loc hm hm?")
                    .font(.system(size: 28, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                VStack {
                    Button {
                        LocationManager.shared.requestLocation()
                    } label: {
                        Text("Allow location")
                            .padding()
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, -32)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .padding()
                    
                    Button {
                        print("Dismiss")
                    } label: {
                        Text("Maybe later")
                            .padding()
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 32)
            }
        }
    }
}

struct UserLocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        UserLocationRequestView()
    }
}
