//
//  PhotoPickerViewModel.swift
//  TravelWell
//
//  Created by Callum Graham on 09/12/2021.
//

import Foundation
import SwiftUI
import UIKit

final class PhotoPickerViewModel : ObservableObject {
    @Published var isSaved = false
    @Published var image: Image?
    @Published var showImagePicker = false
    var expense = Expense()
    
    func setImage(image: Image){
        self.image = image
    }
    
    func setExpense(expense: Expense){
        self.expense = expense
    }
    
    func imageFromExpense(){
        if expense.image != nil{
            image = Image(uiImage: UIImage(data: expense.image!)!)
            
        }
    }
    
}
