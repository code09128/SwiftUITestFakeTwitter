//
//  ImagePicker.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/17.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding
    var selectedImage: UIImage?
    
    @Environment(\.presentationMode)
    var presentationMode
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
        
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

extension ImagePicker {
    class Coordinator: NSObject,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {return}
            parent.selectedImage = image
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
