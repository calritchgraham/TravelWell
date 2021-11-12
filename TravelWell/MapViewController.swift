//
//  MapViewController.swift
//  diss
//
//  Created by Callum Graham on 04/11/2021.
//

import Foundation
import MapKit
import CoreLocation
import Amadeus

final class MapViewController: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager?
   
    func checkLocationServicesEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            checkLocationServicesAuthoriosed()
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        }else{
            //show an alert that location services disable for whole phone
        }
    }
    
    private func checkLocationServicesAuthoriosed() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
            case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("show an alert (parental controls?)") //show alert
            case .denied:
                print("alert you have denied this app location services, this can be changed in settings") //show alert
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                //coordinate = locationManager.location!.coordinate
            @unknown default:
                break
        }

    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {      // checks if authorisation has been changed
        checkLocationServicesEnabled()
    }

}



