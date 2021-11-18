//
//  CovidDataView.swift
//  TravelWell
//
//  Created by Callum Graham on 13/11/2021.
//

import SwiftUI
import WebKit

struct CovidDataView: View {
    @State var covidResults : Welcome
    
    
    var body: some View {   //fix force unwrap
        Text("\(covidResults.data.area.name!)").bold()
        List{
            Section{
                HStack{
                    Text("Infection Risk Level:")
                    Spacer()
                    Text("\(covidResults.data.diseaseRiskLevel!)")

                }
                HStack{
                    Text("Population Fully Vaccinated:")
                    Spacer()
                    Text("\(Int(covidResults.data.areaVaccinated.last!.percentage!))%")
                }
                HStack{
                    Text("Vaccine Pass Required:")
                    Spacer()
                    Text("\(covidResults.data.areaAccessRestriction.diseaseVaccination.isRequired!)")
                }
                HStack{
                    Text("Tracing App Required:")
                    Spacer()
                    Text("\(covidResults.data.areaAccessRestriction.tracingApplication.isRequired!)")

                }
                HStack{
                    Text("Mask Required:")
                    Spacer()
                    Text("\(covidResults.data.areaAccessRestriction.mask.isRequired!)")

                }
            }

            Text("Pre-departure Testing")
            HTMLStringView(htmlContent: covidResults.data.areaAccessRestriction.diseaseTesting.text!).frame(height: 120)
            
            Text("Additional Documentation")
            HTMLStringView(htmlContent: covidResults.data.areaAccessRestriction.declarationDocuments.text!).frame(height: 120)
       
            Text("Quarantine")
            Text("\(covidResults.data.areaAccessRestriction.quarantineModality.text!)") //HTML
            Text("Data Source")
           // Text("\(covidResults.data.dataSources.governmentSiteLink!)")
        }
    }
}

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}


