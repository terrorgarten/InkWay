//
//  CheckBox.swift
//  InkWay
//
//  Created by terrorgarten on 15.03.2024.
//

import SwiftUI

struct IWCheckBox: View {
    @Binding var isChecked: Bool
    var color: Color = .accentColor

    var body: some View {
        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
            .foregroundColor(isChecked ? color : .secondary)
            .onTapGesture {
                self.isChecked.toggle()
            }
            .font(.title) // Adjust size as needed
    }
}

struct CheckBox_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(false) {
            IWCheckBox(isChecked: $0)
        }
        .padding()
    }
}

// Helper wrapper to create state in previews
struct StatefulPreviewWrapper<Value>: View {
    @State private var value: Value
    let content: (Binding<Value>) -> IWCheckBox

    init(_ value: Value, content: @escaping (Binding<Value>) -> IWCheckBox) {
        self._value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
