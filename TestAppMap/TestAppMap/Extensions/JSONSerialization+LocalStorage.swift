//
//  JSONSerialization+LocalStorage.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 29.10.22.
//

import Foundation

extension JSONSerialization {
  
  static func loadJSON(withFilename filename: String) throws -> Any? {
   
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    if let url = urls.first {
      var fileURL = url.appendingPathComponent(filename)
      fileURL = fileURL.appendingPathExtension("json")
      let data = try Data(contentsOf: fileURL)
      let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
      return jsonObject
    }
    
    return nil
  }
  
  static func save(jsonObject: Any, toFilename filename: String) throws -> Bool {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    if let url = urls.first {
      var fileURL = url.appendingPathComponent(filename)
      fileURL = fileURL.appendingPathExtension("json")
      let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
      try data.write(to: fileURL, options: [.atomicWrite])
      return true
    }
    
    return false
  }
}
