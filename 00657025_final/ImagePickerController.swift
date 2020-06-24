//
//  ImagePickerController.swift
//  00657025_final
//
//  Created by User19 on 2020/6/22.
//  Copyright © 2020 User23. All rights reserved.
//

import SwiftUI

struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var selectImage: UIImage?
    @Binding var showSelectPhoto: Bool
    
    func makeCoordinator() -> ImagePickerController.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var imagePickerController: ImagePickerController
        
        init(_ imagePickerController: ImagePickerController) {
            self.imagePickerController = imagePickerController
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imagePickerController.showSelectPhoto = false
            imagePickerController.selectImage = info[.originalImage] as? UIImage
        }
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerController>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerController>) {
    }
}

