//
//  EditDesignView.swift
//  InkWay
//
//  Created by Oliver Bajus on 07.05.2024.
//

import SwiftUI
import PhotosUI
import WrappingHStack

struct EditDesignView: View {
    @StateObject var viewModel: EditDesignViewModel
    @State private var options: [Tag] = sampleTags
    @Binding var isViewShowing: Bool
    @Binding var posts: [PostModel]
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("Loading. Please wait a few seconds...")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    Form {
                        if (!viewModel.designUploaded && viewModel.designError != nil) {
                            Section(footer: IWErrorMessageBar(message: viewModel.designError ?? "Something went wrong, try again.")) {}
                        }
                        Section(header: Text("Name"), content: {
                            TextField("Type name...", text: $viewModel.designName, axis: .vertical)
                                .lineLimit(1, reservesSpace: true)
                        })
                        Section(header: Text("Descritpion"), content: {
                            TextField("Type something...", text: $viewModel.designDescription, axis: .vertical)
                                .lineLimit(1, reservesSpace: true)
                        })
                        Section(header: Text("Price"), content: {
                            TextField("Enter your price", value: $viewModel.designPrice, format: .number)
                                .lineLimit(1, reservesSpace: true)
                        })

                        Section(header: Text("Image"), content: {
                            VStack(alignment: .center){
                                PhotosPicker(selection: $viewModel.imageSelection,
                                             matching: .images,
                                             photoLibrary: .shared()){
                                        Label("Select image", systemImage: "photo")
                                            .labelStyle(.titleAndIcon)
                                            .frame(width: 315)
                                }
                                .buttonStyle(.bordered)
                                
                                DesignImage(imageState: viewModel.imageState)
                            }
                                
                        })
                        
                        Section(header: Text("Tags"), content: {
                            NavigationLink {
                                MultiSelectPickerView(sourceItems: options, selectedItems: $viewModel.designTagsSelection)
                            } label: {
                                Text("Choose tags")
                            }
                            HStack {
                                VStack(alignment: .leading){
                                    Text("Chosen tags:")
                                    if $viewModel.designTagsSelection.isEmpty {
                                        Text("No tags selected")
                                            .multilineTextAlignment(.center)
                                            .font(.system(.footnote))
                                    } else {
                                        WrappingHStack($viewModel.designTagsSelection, id: \.self) { tag in
                                            Button(action: {}){
                                                IWTag(text: tag.text.wrappedValue)
                                                    .padding(.vertical, 2)
                                            }
                                        }
                                    }
                                }
                            }
                        }).frame(maxHeight: .infinity)
                    }
                }
            }
            .navigationTitle("Edit design")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(){
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Save"){
                        viewModel.uploadDesign()
                    }.fontWeight(.bold)
                    .disabled(viewModel.isLoading)
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        isViewShowing = false
                    }.fontWeight(.bold)
                    .disabled(viewModel.isLoading)
                }
            }
            .alert("Design successfully edited", isPresented: $viewModel.designUploaded) {
                Button("OK", role: .cancel) {
                    if let design = viewModel.updatedDesign {
                        posts = posts.filter{ $0.design.id != design.id }
                        posts.append(.init(design: design, artist: viewModel.postModel.artist, isLiked: viewModel.postModel.isLiked))
                        isViewShowing = false
                    }
                }
            }
            .onAppear {
                if !viewModel.isDesignLoaded {
                    viewModel.loadDesign()
                }
            }
        }
    }
    
}
