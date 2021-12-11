//
//  ExpenseReportViewModel.swift
//  TravelWell
//
//  Created by Callum Graham on 11/12/2021.
//

import Foundation
import SwiftUI

final class ExpensesReportViewModel: ObservableObject {
    var trip: Trip!
    var sortedExpenses = [Expense]()
    
    func setTrip(trip: Trip){
        self.trip = trip
    }
    
    func sortExpenses(){
        if trip.expense != nil {
            for expense in Array(trip.expense as! Set<Expense>) {
                sortedExpenses.append(expense)
            }
           
            sortedExpenses.sorted(by: {$0.date! < $1.date!})
            print(sortedExpenses)
        }
    }
}
