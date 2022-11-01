//
//  UserDetails.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 30.10.22.
//

import Foundation

struct VehicleLocation: Codable {
    let data: [MapObjectData]
}

// MARK: - Datum
struct MapObjectData: Codable {
    let vehicleid: Int
    let lat, lon: Double
}
