//
//  ExpenseReportView.swift
//  TravelWell
//
//  Created by Callum Graham on 11/12/2021.
//

import SwiftUI

struct ExpenseReportView: View {
    var trip: Trip
    @StateObject var expenseReportViewModel = ExpensesReportViewModel()
    @State var isLoading = true
    
    var body: some View {
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
                    Section{
                        Button("Save to Album") {
                            let image = body.snapshot()
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }
                    }
                }
            }
        }.navigationBarHidden(true)
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
