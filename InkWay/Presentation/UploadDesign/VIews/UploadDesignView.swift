//
//  UploadDesignView.swift
//  InkWay
//
//  Created by terrorgarten on 31.05.2023.
//

import SwiftUI
import PhotosUI
import WrappingHStack

struct UploadDesignView: View {
    @StateObject private var viewModel = UploadDesignViewModel()
    @State private var options: [Tag] = sampleTags

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isUploading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("We are uploading your design. Please wait a few seconds...")
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
            .navigationTitle("Upload design")
            .toolbar(){
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        viewModel.clearInputs()
                    }
                    .disabled(viewModel.isUploading)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Upload"){
                        viewModel.uploadDesign()
                        viewModel.navigateToHome()
                    }.fontWeight(.bold)
                    .disabled(viewModel.isUploading)
                }
            }
            .alert("Design successfully uploaded", isPresented: $viewModel.designUploaded) {
                Button("OK", role: .cancel) { }
            }
        }
    }
    
}

struct DesignImage: View {
    let imageState: UploadDesignViewModel.ImageState
    
    var body: some View{
        switch imageState {
        case .success(let image):
            Image(uiImage: image).resizable()
                .scaledToFill()
                .frame(width: 335, height: 330)
                .cornerRadius(8)
                .clipped()
        case .loading:
            ProgressView()
        case .empty:
            EmptyView()
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

struct UploadDesign_Previews: PreviewProvider {
    static var previews: some View {
        UploadDesignView()
    }
}
