//
//  IWProfilePicturePicker.swift
//  InkWay
//
//  Created by terrorgarten on 16.03.2024.
//

import SwiftUI

struct IWProfilePicturePicker: View {
    var description: String
    @State var profileImage: Image? = nil
    var action: () -> Void

    var body: some View {
        VStack{
            ZStack {
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("SecondaryColor").opacity(0.4))
                }

                Circle()
                    .strokeBorder(style: StrokeStyle(lineWidth: 6, dash: [0.1]))
                    .foregroundColor(Color.accentColor)
            }
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.accentColor, lineWidth: 4)
                    .frame(width: 154, height: 154)
            )
            Text(description)
                .fontWeight(.semibold)
                .foregroundColor(Color.accentColor)
                .padding(.top)
        }
        .onTapGesture {
            action()
        }
    }
}

struct IWProfilePicturePicker_Previews: PreviewProvider {
    static var previews: some View {
        IWProfilePicturePicker(description: "Preview description") {
            print("UserProfilePicPicker tapped")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
