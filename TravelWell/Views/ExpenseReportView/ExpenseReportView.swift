//
//  ExpenseReportView.swift
//  TravelWell
//
//  Created by Callum Graham on 11/12/2021.
//

import SwiftUI
import UIKit

struct ExpenseReportView: View {
    var trip: Trip
    @StateObject var expenseReportViewModel = ExpensesReportViewModel()
    @State var isLoading = true
    
    var expenseView: some View {
        NavigationView{
            if self.isLoading{
                Text("Loading...").onAppear{
                    expenseReportViewModel.setTrip(trip: trip)
                    expenseReportViewModel.sortExpenses()
                    self.isLoading = false
                }
            }else {
                List{
                    Section{
                        Text("Expense Report from \(trip.outbound!, style: .date) to \(trip.inbound!, style: .date)").bold()
                    }
                    ForEach(expenseReportViewModel.sortedExpenses, id:\.self) { item in
                        Section{
                            VStack{
                                Text("\(item.date!, style: .date)").bold()
                                HStack{
                                    Text(item.occasion!)
                                    Spacer()
                                    Text(item.currency!)
                                    Spacer()
                                    Text(String(item.amount))
                                }
                                if item.image != nil {
                                    Image(uiImage: UIImage(data: item.image!)!).resizable().scaledToFit()
                                }
                            }
                        }
                    }
                }
            }
        }.navigationBarHidden(true)
    }
    
    var body: some View{
        VStack{
            expenseView
            
            Section{
                Button("Save to Album") {
                    let image = expenseView.snapshot()
                    let imageSaver = ImageSaver()
                    imageSaver.writeToPhotoAlbum(image: image)
                }
            }
        }
    }
}

extension View {                    // extend view to create photo from view
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)  //wrap view in UIKit controller
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize   //set target size same as original view
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in                                //render image
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

class ImageSaver: NSObject {                    //save image to album and completion handler
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished")
    }
}
