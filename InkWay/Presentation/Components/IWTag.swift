//
//  Tag.swift
//  InkWay
//
//  Created by terrorgarten on 15.03.2024.
//

import SwiftUI

struct IWTag: View {
    var text: String
    var showsCross: Bool = false
    var color: Color = Color.accentColor
    var onCrossPressed: () -> Void = {}

    var body: some View {
        HStack {
            Text(text)
                .padding(.horizontal, showsCross ? 4 : 10)
                .padding(.vertical, 5)
                .foregroundColor(.white)

            if showsCross {
                Button(action: onCrossPressed) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .imageScale(.small)
                }
                .padding(.leading, -8)
            }
        }
        .padding(.horizontal, showsCross ? 8 : 0)
        .background(color)
        .cornerRadius(15)
    }
}

struct Tag: Identifiable, Hashable {
    let id = UUID()
    var text: String
}

let sampleTags: [Tag] = [
    Tag(text: "Traditional"),
    Tag(text: "Neo Traditional"),
    Tag(text: "Realism"),
    Tag(text: "Watercolor"),
    Tag(text: "Tribal"),
    Tag(text: "New School"),
    Tag(text: "Japanese"),
    Tag(text: "Dotwork"),
    Tag(text: "Geometric"),
    Tag(text: "Abstract"),
    Tag(text: "Portraiture"),
    Tag(text: "Blackwork")
]

struct IWTag_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ForEach(sampleTags, id: \.self) { tag in
                IWTag(text: tag.text, showsCross: true) {
                    print("IWTag tapepd!")
                }
            }
        
        }
    }
}
