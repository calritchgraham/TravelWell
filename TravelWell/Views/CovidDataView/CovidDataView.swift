//
//  CovidDataView.swift
//  TravelWell
//
//  Created by Callum Graham on 13/11/2021.
//

import SwiftUI

struct CovidDataView: View {
    @State var covidResults : CovidData
    
    var body: some View { 
        Text("\(covidResults.data.area.name!)").bold()
        List{
            Section{
                if covidResults.data.diseaseRiskLevel != nil {
                    HStack{
                        Text("Infection Risk Level:")
                        Spacer()
                        Text("\(covidResults.data.diseaseRiskLevel!)")
                    }
                }
                
                if covidResults.data.areaVaccinated.last!.percentage != nil {
                    HStack{
                        Text("Population Fully Vaccinated:")
                        Spacer()
                        Text("\(Int(covidResults.data.areaVaccinated.last!.percentage!))%")
                    }
                }
                
                if covidResults.data.areaAccessRestriction.diseaseVaccination.isRequired != nil {
                    HStack{
                        Text("Vaccine Pass Required:")
                        Spacer()
                        Text("\(covidResults.data.areaAccessRestriction.diseaseVaccination.isRequired!)")
                    }
                }
                if covidResults.data.areaAccessRestriction.tracingApplication.isRequired != nil {
                    HStack{
                        Text("Tracing App Required:")
                        Spacer()
                        Text("\(covidResults.data.areaAccessRestriction.tracingApplication.isRequired!)")
                    }
                }
            
                if covidResults.data.areaAccessRestriction.mask.isRequired != nil {
                    HStack{
                        Text("Mask Required:")
                        Spacer()
                        Text("\(covidResults.data.areaAccessRestriction.mask.isRequired!)")
                    }
                }
            }

            if covidResults.data.areaAccessRestriction.diseaseTesting.text != nil{
                Text("Pre-departure Testing")
                HTMLStringView(htmlContent: covidResults.data.areaAccessRestriction.diseaseTesting.text!).frame(height: 120)
            }
            
            if covidResults.data.areaAccessRestriction.declarationDocuments.text != nil {
                Text("Additional Documentation")
                HTMLStringView(htmlContent: covidResults.data.areaAccessRestriction.declarationDocuments.text!).frame(height: 120)
            }
            
            if covidResults.data.areaAccessRestriction.quarantineModality.text != nil{
                Text("Quarantine")
                HTMLStringView(htmlContent:covidResults.data.areaAccessRestriction.quarantineModality.text!)
            }
            
            if covidResults.data.dataSources.governmentSiteLink != nil {
                Text("Data Source")
                HTMLStringView(htmlContent: covidResults.data.dataSources.governmentSiteLink!)
            }
            
        }
    }
}




