//
//  IWTagPicker.swift
//  InkWay
//
//  Created by terrorgarten on 15.03.2024.
//

import SwiftUI

struct IWTagPicker: View {
    @State private var selectedTags: Set<Tag> = []
    @State private var customTagString: String = ""

    private func isTagAlreadyPresent(tagString: String) -> Bool {
        return selectedTags.contains(where: { $0.text.lowercased() == tagString.lowercased() })
    }
    
    var body: some View {
        VStack {
            
            // User selected tags, removable via clicking the cross icon
            IWFlowLayout(Array(selectedTags), spacing: 6) { tag in
                IWTag(text: tag.text, showsCross: true) {
                    selectedTags.remove(tag)
                }
            }
            .padding(.bottom, 40)
            
            TextField("Enter your own tag", text: $customTagString, onCommit: {
                guard !customTagString.isEmpty, selectedTags.count < 5 else { return }
                let newTag = Tag(text: customTagString)
                guard !isTagAlreadyPresent(tagString: customTagString) else { return }
                selectedTags.insert(newTag)
                customTagString = ""
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Sample tags that the user can click to add them to their selected tags
            IWFlowLayout(sampleTags, spacing: 6) { tag in
                Button(action: {
                    guard selectedTags.count < 5 else { return }
                    selectedTags.insert(tag)
                }) {
                    IWTag(text: tag.text, color: selectedTags.contains(tag) ? Color.gray : Color.blue)
                }
                .disabled(selectedTags.contains(tag))
            }
            .padding(.top)
        }
        .padding()
    }
}

struct IWTagPicker_Previews: PreviewProvider {
    static var previews: some View {
        IWTagPicker()
    }
}

