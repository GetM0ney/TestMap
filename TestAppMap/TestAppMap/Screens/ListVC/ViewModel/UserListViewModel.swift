//
//  UserListViewModel.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 30.10.22.
//

import Foundation
import UIKit
//вынестип лист
final class UserListViewModel {
  //иджект
  var networkManager: NetworkManager = NetworkManager()
  var users: [User]?
  
  func getUsersData(completion: @escaping () -> Void) {
    if let requestDateString = UserDefaults.standard.object(forKey: "RequestDay") as? String, Date().getDayMonthString() != requestDateString {
      requestData { completion() }
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
  
  private func requestData(completion: @escaping ()-> Void) {
    guard let url = URL(string: "http://mobi.connectedcar360.net/api/?op=list") else { return }
    networkManager.request(fromURL: url) { (result: Result<UserList, Error>) in
      switch result {
        case .success(let list):
          self.users = list.data.filter({ $0.owner != nil })
          DataManager.save(list, with: "UserList")
          UserDefaults.standard.set(Date().getDayMonthString(), forKey: "RequestDay")
          completion()
        case .failure(let error):
          debugPrint("We got a failure trying to get the data. The error we got was: \(error.localizedDescription)")
      }
    }
  }
}
