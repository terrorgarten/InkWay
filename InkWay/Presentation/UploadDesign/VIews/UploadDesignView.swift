//
//  UploadDesignView.swift
//  InkWay
//
//  Created by terrorgarten on 31.05.2023.
//

import SwiftUI
import PhotosUI


// Present just few buttons and then call the custom image picker
struct UploadDesignView: View {
    
    @StateObject private var viewModel = UploadDesignViewModel()
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationStack {
            VStack(){
                TextField("Description...", text: $viewModel.description, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(5, reservesSpace: true)
                    .padding()
                                
                PhotosPicker(selection: $viewModel.imageSelection,
                             matching: .images,
                             photoLibrary: .shared()){
                        Label("Select image", systemImage: "photo")
                            .labelStyle(.titleAndIcon)
                            .frame(width: 335)
                }
                .buttonStyle(.bordered)
                .padding([.horizontal, .bottom])
                
                DesignImage(imageState: viewModel.imageState)

                if viewModel.isUploading {
                    ProgressView("Uploading", value: viewModel.uploadProgress, total: 1.0)
                        .padding()
                }
                
                if let error = viewModel.uploadError {
                    Text("Error during the image upload: \(error.localizedDescription) Try again please.")
                        .foregroundColor(.red)
                        .padding()
                }
                
                if viewModel.designUploaded {
                    Text("Image Uploaded Successfully!")
                        .foregroundColor(.green)
                        .padding()
                }
                Spacer()
            }
            .navigationTitle("Upload design")
            .toolbar(){
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Upload"){
                        
                    }.fontWeight(.bold)
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
                .frame(width: 350, height: 350)
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
