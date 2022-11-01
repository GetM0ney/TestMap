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
  
  let vehicleid: Int
  let make, model, year, color: String
  let vin: String
  let foto: String
  
  init(vehicleid: Int, make: String, model: String, year: String, color: String, vin: String, foto: String, coordinate: CLLocationCoordinate2D) {
    self.vehicleid = vehicleid
    self.make = make
    self.model = model
    self.year = year
    self.color = color
    self.vin = vin
    self.foto = foto
    self.coordinate = coordinate
    self.title = make + " " + model
  }
}
