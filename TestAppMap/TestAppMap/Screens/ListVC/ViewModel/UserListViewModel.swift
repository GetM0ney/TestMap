//
//  UserListViewModel.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 30.10.22.
//

import Foundation
import UIKit

final class UserListViewModel {
  var networkManager: NetworkManager!
  var users: [User]?
  
  init(networkManager: NetworkManager!) {
    self.networkManager = networkManager
  }
  
  func getUsersData(completion: @escaping (_ error: Error?) -> Void) {
    if let requestDateString = UserDefaults.standard.object(forKey: "RequestDay") as? String, Date().getDayMonthString() != requestDateString {
      requestData { error in completion(error) }
    } else {
      guard let data = DataManager.load("UserList") else { return }
      do {
        let users = try JSONDecoder().decode(UserList.self, from: data)
        self.users = users.data.filter({ $0.owner != nil })
      } catch {
        debugPrint("Could not translate the data to the requested type. Reason: \(error.localizedDescription)")
      }
    }
  }
  
  private func requestData(completion: @escaping (_ error: Error?)-> Void) {
    guard let url = URL(string: NetworkManager.RequestsString.getUsers.stringValue) else { return }
    networkManager.request(fromURL: url) { (result: Result<UserList, Error>) in
      switch result {
        case .success(let list):
          self.users = list.data.filter({ $0.owner != nil })
          DataManager.save(list, with: "UserList")
          UserDefaults.standard.set(Date().getDayMonthString(), forKey: "RequestDay")
          completion(nil)
        case .failure(let error):
          completion(error)
          debugPrint("We got a failure trying to get the data. The error we got was: \(error.localizedDescription)")
      }
    }
  }
}
