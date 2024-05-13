//
//  IWProfilePictureView.swift
//  InkWay
//
//  Created by terrorgarten on 11.05.2024.
//

import SwiftUI

struct IWProfilePictureView: View {
    @Binding var image: Image?
    var placeholderText: String = "Tap to select a picture"
    
    @State private var isShowingImagePicker = false
    
    var body: some View {
        Button(action: {
            isShowingImagePicker = true
        }) {
            VStack {
                if let image = image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                } else {
                    Text(placeholderText)
                        .foregroundColor(.blue)
                        .frame(width: 200, height: 200)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: self.$image)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: Image?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true  // Should allow image editing
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.editedImage] as? UIImage {
                parent.image = Image(uiImage: uiImage)
            } else if let uiImage = info[.originalImage] as? UIImage {
                parent.image = Image(uiImage: uiImage)
            }
            picker.dismiss(animated: true)
        }
    }
}

struct IWProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var image: Image? = nil  // For correct preview (must be state-binding)

        var body: some View {
            IWProfilePictureView(image: $image)
        }
    }
}

