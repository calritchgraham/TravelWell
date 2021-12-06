//
//  Location.swift
//  TravelWell
//
//  Created by Callum Graham on 06/12/2021.
//

import Foundation
import CoreLocation

struct Location: Identifiable {
  let id = UUID()
  let coordinate: CLLocationCoordinate2D
}
