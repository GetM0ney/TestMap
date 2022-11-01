//
//  User.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 29.10.22.
//

import Foundation

// MARK: - UserList
struct UserList: Codable {
    let data: [User]
}

// MARK: - Datum
struct User: Codable {
    let userid: Int?
    let owner: Owner?
    let vehicles: [Vehicle]?
}

// MARK: - Owner
struct Owner: Codable {
    let name, surname: String
    let foto: String 
}

// MARK: - Vehicle
struct Vehicle: Codable {
    let vehicleid: Int
    let make, model, year, color: String
    let vin: String
    let foto: String
}
