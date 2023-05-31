//
//  UploadDesignView.swift
//  InkWay
//
//  Created by terrorgarten on 31.05.2023.
//

import SwiftUI



// Present just few buttons and then call the custom image picker
struct UploadDesignView: View {
    
    @StateObject private var viewModel = UploadDesignViewModel()
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Please note that only the first image is viewed on your profile when people find you!")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .padding()
                Spacer()
                
                if let designImage = selectedImage {
                    Image(uiImage: designImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                } else {
                    Text("No image selected")
                }
                
                Button("Select Image") {
                    showImagePicker = true
                }
                .padding()
                .sheet(isPresented: $showImagePicker) {
                    ImagePickerView(selectedImage: $selectedImage)
                }
                
                Button("Upload Image") {
                    if let image = selectedImage {
                        viewModel.designImage = image
                        viewModel.uploadDesignImage()
                    }
                }
                .padding()
                // live update the button status
                .disabled(selectedImage == nil || viewModel.isUploading)
                
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
        }
        .navigationBarTitle("Upload design")
    }
    
}
