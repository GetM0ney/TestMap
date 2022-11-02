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
  var vehiclesLocationDataDictionary = [Int: CLLocationCoordinate2D]()
  var usersVehicleData: User?
  var vehiclesWithLocation = [VehicleWithLocation]()
  
  init(networkManager: NetworkManager!, usersVehicleData: User?) {
    self.networkManager = networkManager
    self.usersVehicleData = usersVehicleData
  }
  
  func getLocationData(completion: @escaping (_ error: Error?) -> Void) {
    guard let userId = usersVehicleData?.userid,
          let url = URL(string: NetworkManager.RequestsString.getLocations(id: userId).stringValue),
          let networkManager = networkManager else { return }
    networkManager.request(fromURL: url) { (result: Result<VehicleLocation, Error>) in
      switch result {
        case .success(let locations):
          locations.data.forEach { location in
            self.vehiclesLocationDataDictionary.updateValue(CLLocationCoordinate2D(latitude: location.lat,
                                                                                   longitude: location.lon),
                                                            forKey: location.vehicleid)
          }
          self.createVehiclesWithLocation()
          completion(nil)
        case .failure(let error):
          completion(error)
          debugPrint("We got a failure trying to get the data. The error we got was: \(error.localizedDescription)")
      }
    }
  }
  
  func createVehiclesWithLocation() {
    vehiclesWithLocation.removeAll()
    usersVehicleData?.vehicles?.forEach({ item in
      if let coordinates = vehiclesLocationDataDictionary[item.vehicleid] {
        let vehicleWithLocation = VehicleWithLocation(coordinate: coordinates, vehicle: item)
        vehiclesWithLocation.append(vehicleWithLocation)
      }
    })
  }
}
