//
//  UserDefaultsManager.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 31.10.22.
//

import Foundation

class UserDefaultsManager {
  static let shared = UserDefaultsManager()
  
  let keyForDate = "RequestDay"
  
  func isDataUpdateNeeded() -> Bool {
    if let requestDateString = UserDefaults.standard.object(forKey: keyForDate) as? String, Date().getDayMonthString() != requestDateString {
      return true
    } else {
      return false
    }
  }
  
  func setDate() {
    UserDefaults.standard.set(Date().getDayMonthString(), forKey: keyForDate)
  }
}
