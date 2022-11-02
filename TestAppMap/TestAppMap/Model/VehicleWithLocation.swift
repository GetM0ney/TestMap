//
//  VehicleWithLocation.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 30.10.22.
//

import Foundation
import MapKit

class VehicleWithLocation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  
  let vehicle: Vehicle
  
  init(coordinate: CLLocationCoordinate2D, vehicle: Vehicle) {
    self.vehicle = vehicle
    self.coordinate = coordinate
    self.title = vehicle.make + " " + vehicle.model
  }
}
