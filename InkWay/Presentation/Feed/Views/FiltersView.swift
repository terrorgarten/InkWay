//
//  FiltersView.swift
//  InkWay
//
//  Created by Oliver Bajus on 02.05.2024.
//

import Foundation
import SwiftUI
import WrappingHStack

struct FiltersView: View {
    @State var isDarkModeEnabled: Bool = true
    @State var downloadViaWifiEnabled: Bool = false
    @Binding var distatnce: Double
    @Binding var isPresented: Bool
    
    @Binding var selection: [Tag]
    @State private var options: [Tag] = sampleTags
    
    var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("DISTANCE"), content: {
                        HStack {
                            Text("0km")
                            Slider(value: $distatnce, in: 0...250)
                            Text("250km")
                        }
                    })

                    Section(header: Text("TAGS"), content: {
                        NavigationLink {
                            MultiSelectPickerView(sourceItems: options, selectedItems: $selection)
                        
                        } label: {
                            Text("Choose tags")
                        }
                        HStack {
                            VStack(alignment: .leading){
                                Text("Chosen tags:")
                                if selection.isEmpty {
                                    Text("No tags selected")
                                        .multilineTextAlignment(.center)
                                        .font(.system(.footnote))
                                } else {
                                    WrappingHStack(selection, id: \.self) { tag in
                                        Button(action: {}){
                                            IWTag(text: tag.text)
                                                .padding(.vertical, 2)
                                        }
                                    }
                                    Button(action:  { selection = [] }) {
                                        Text("Reset")
                                    }
                                }
                            }
                        }
                    }).frame(maxHeight: .infinity)
                }
                .navigationBarTitle("Feed filters")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") {
                            isPresented = false
                        }
                    }
                }
            }
            
        }
}

struct MultiSelectPickerView: View {
    @State var sourceItems: [Tag]
    
    @Binding var selectedItems: [Tag]
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            Form {
                List {
                    ForEach(searchResults) { item in
                        Button(action: {
                            withAnimation {
                                if self.selectedItems.contains(item) {
                                    self.selectedItems.removeAll(where: { $0 == item })
                                } else {
                                    self.selectedItems.append(item)
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "checkmark")
                                    .opacity(self.selectedItems.contains(item) ? 1.0 : 0.0)
                                Text("\(item.text)")
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .navigationBarTitle("Choose tags")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText)
    }
    
    var searchResults: [Tag] {
        if searchText.isEmpty {
            return sourceItems
        } else {
            return sourceItems.filter { $0.text.contains(searchText) }
        }
    }
}
    

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView(distatnce: .constant(0), isPresented: .constant(false), selection: .constant([]))
    }
}

