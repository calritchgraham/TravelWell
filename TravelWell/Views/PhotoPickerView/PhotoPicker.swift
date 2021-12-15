//
//  PhotoPickerViewModel.swift
//  TravelWell
//
//  Created by Callum Graham on 09/12/2021.
//

import Foundation
import SwiftUI
import UIKit

struct PhotoPicker: UIViewControllerRepresentable {             //use UIKit as no SwiftUI way to achieve this
   
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {      //internal class delegate
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {           //set delegate as self
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<PhotoPicker>) {

    }
}
