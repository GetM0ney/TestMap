//
//  DetailsViewModel.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 30.10.22.
//

import Foundation
import MapKit

final class DetailsViewModel {
 
  var networkManager: NetworkManager!
  var vehiclesLocationData: [MapObjectData]?
  var usersVehicleData: User?
  var vehiclesWithLocation = [VehicleWithLocation]()
  
  init(networkManager: NetworkManager!, vehiclesLocationData: [MapObjectData]? = nil, usersVehicleData: User? = nil, vehiclesWithLocation: [VehicleWithLocation] = [VehicleWithLocation]()) {
    self.networkManager = networkManager
    self.vehiclesLocationData = vehiclesLocationData
    self.usersVehicleData = usersVehicleData
    self.vehiclesWithLocation = vehiclesWithLocation
  }
  
  func getLocationData(completion: @escaping (_ error: Error?) -> Void) {
    guard let userId = usersVehicleData?.userid,
          let url = URL(string: NetworkManager.RequestsString.getLocations(id: userId).stringValue),
          let networkManager = networkManager else { return }
    networkManager.request(fromURL: url) { (result: Result<VehicleLocation, Error>) in
      switch result {
        case .success(let locations):
          self.vehiclesLocationData = locations.data
          self.createVehiclesWithLocation()
          completion(nil)
        case .failure(let error):
          completion(error)
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
        let vehicleWithLocation = VehicleWithLocation(coordinate: coordinates, vehicle: item)
        vehiclesWithLocation.append(vehicleWithLocation)
      }
    })
  }
}
