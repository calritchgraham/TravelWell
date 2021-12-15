//
//  PhotoPickerView.swift
//  TravelWell
//
//  Created by Callum Graham on 09/12/2021.
//

import SwiftUI
import CoreData

struct PhotoPickerView: View {
    
    var expense: Expense
    @State private var inputImage: UIImage?
    @StateObject private var photoPickerViewModel =  PhotoPickerViewModel()
    
    func save() {
        let pickedImage = inputImage?.jpegData(compressionQuality: 1.0)     //convert from jpeg to binary data to save in CoreData
        expense.image = pickedImage
        PersistenceController.shared.save()
        photoPickerViewModel.isSaved = true
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        photoPickerViewModel.setImage(image: Image(uiImage: inputImage))
    }

    var body: some View {
        NavigationView {
           Form {
               Section() {
                   if photoPickerViewModel.image != nil {
                       photoPickerViewModel.image!
                           .resizable()
                           .scaledToFit()
                           .onTapGesture { photoPickerViewModel.showImagePicker.toggle() }
                   } else {
                       Button(action: { photoPickerViewModel.showImagePicker.toggle() }) {
                           Text("Select Image")
                               .accessibility(identifier: "Select Image")
                       }
                   }
               }
               if !photoPickerViewModel.isSaved{
                   Section {
                       Button(action: self.save) {
                           Text("Save")
                       }
                   }
               }
           }.sheet(isPresented: $photoPickerViewModel.showImagePicker, onDismiss: self.loadImage) { PhotoPicker(image: self.$inputImage) }
        }.onAppear{
            photoPickerViewModel.setExpense(expense: expense)
            photoPickerViewModel.imageFromExpense()
        }
    }
}
