//
//  ImagePickerView.swift
//  InkWay
//
//  Created by terrorgarten on 31.05.2023.
//

import PhotosUI
import SwiftUI

// DISCLAIMER - heavily inspired by stackoverflow and docs
// Creates UIkit-ish picker which then appears as sheet.
struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        picker.view.tintColor = UIColor.systemMint
        picker.view.isOpaque = true
        return picker
    }
    
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    
    // manages the action chaining
    class Coordinator: PHPickerViewControllerDelegate {
        
        let parent: ImagePickerView
        
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        
        // finishes the picking
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            
            guard let itemProvider = results.first?.itemProvider else {
                return
            }
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.parent.selectedImage = image
                        }
                    }
                }
            }
        }
    }
    
}
