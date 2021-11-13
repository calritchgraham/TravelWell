//
//  CovidDataView.swift
//  TravelWell
//
//  Created by Callum Graham on 13/11/2021.
//

import SwiftUI

struct CovidDataView: View {
    @State var covidResults : Welcome
    
    var body: some View {
        Text("\(covidResults.data.area.name)").bold()
        List{
            Section{
                HStack{
                    Text("Population Fully Vaccinated:")
                    Spacer()
                    Text("\(Int(covidResults.data.areaVaccinated.last!.percentage))%")
                }
                HStack{
                    Text("Vaccine Pass Required:")
                    Spacer()
                    Text("\(covidResults.data.areaAccessRestriction.diseaseVaccination.isRequired)")
                }
                HStack{
                    Text("Tracing App Required:")
                    Spacer()
                    Text("\(covidResults.data.areaAccessRestriction.tracingApplication.isRequired)")
                    
                }
                HStack{
                    Text("Mask Required:")
                    Spacer()
                    Text("\(covidResults.data.areaAccessRestriction.mask.isRequired)")
                    
                }
            }
            
            Text("Pre-departure Testing")
            Text("\(covidResults.data.areaAccessRestriction.diseaseTesting.text)") //HTML
            Text("Additional Documentation")
            Text("\(covidResults.data.areaAccessRestriction.declarationDocuments.text)")  //HTML
            Text("Quarantine")
            Text("\(covidResults.data.areaAccessRestriction.quarantineModality.text)") //HTML
            
            
            
        }
    }
}


