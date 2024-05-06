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
    @EnvironmentObject var router: BaseRouter

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Descritpion"), content: {
                    TextField("Type something...", text: $viewModel.description, axis: .vertical)
                        .lineLimit(5, reservesSpace: true)
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
                        MultiSelectPickerView(sourceItems: options, selectedItems: $viewModel.tagsSelection)
                    } label: {
                        Text("Choose tags")
                    }
                    HStack {
                        VStack(alignment: .leading){
                            Text("Chosen tags:")
                            if $viewModel.tagsSelection.isEmpty {
                                Text("No tags selected")
                                    .multilineTextAlignment(.center)
                                    .font(.system(.footnote))
                            } else {
                                WrappingHStack($viewModel.tagsSelection, id: \.self) { tag in
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
            .navigationTitle("Upload design")
            .toolbar(){
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        viewModel.navigateToHome()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Upload"){
                        viewModel.uploadDesignImage()
                        viewModel.navigateToHome()
                    }.fontWeight(.bold)
                }
            }
            .onChange(of: viewModel.navigateToPath) { _ in
                if let destination = viewModel.navigateToPath {
                    viewModel.navigateToPath = nil
                    router.navigate(to: destination)
                }
            }
        }
    }
    
}

struct DesignImage: View {
    let imageState: UploadDesignViewModel.ImageState
    
    var body: some View{
        switch imageState {
        case .success(let image):
            image.resizable()
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
