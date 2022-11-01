//
//  DetailsViewModel.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 30.10.22.
//

import Foundation
import MapKit

final class DetailsViewModel {
 
  var networkManager: NetworkManager?
  var vehiclesLocationData: [MapObjectData]?
  var usersVehicleData: User?
  var vehiclesWithLocation = [VehicleWithLocation]()
  
  func getLocationData(completion: @escaping () -> Void) {
    guard let userId = usersVehicleData?.userid,
          let url = URL(string: "https://mobi.connectedcar360.net/api/?op=getlocations&userid=\(userId)"),
          let networkManager = networkManager else { return }
    networkManager.request(fromURL: url) { (result: Result<VehicleLocation, Error>) in
      switch result {
        case .success(let locations):
          self.vehiclesLocationData = locations.data
          self.createVehiclesWithLocation()
          completion()
        case .failure(let error):
          debugPrint("We got a failure trying to get the data. The error we got was: \(error.localizedDescription)")
      }
    }
  }
  
  func createVehiclesWithLocation() {
    usersVehicleData?.vehicles?.forEach({ item in
      guard let locationsData = vehiclesLocationData else { return }
      let index = locationsData.firstIndex { locationData in item.vehicleid == locationData.vehicleid }
      if let index = index {
        let coordinates = CLLocationCoordinate2D(latitude: locationsData[index].lat, longitude: locationsData[index].lon)
        let vehicleWithLocation = VehicleWithLocation(vehicleid: item.vehicleid,
                                                      make: item.make,
                                                      model: item.model,
                                                      year: item.year,
                                                      color: item.color,
                                                      vin: item.vin,
                                                      foto: item.foto,
                                                      coordinate: coordinates)
        vehiclesWithLocation.append(vehicleWithLocation)
      }
    })
  }
}
