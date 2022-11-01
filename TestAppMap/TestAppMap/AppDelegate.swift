//
//  AppDelegate.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 29.10.22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let userListViewModel = UserListViewModel(networkManager: NetworkManager())
    guard let controller = UIStoryboard.init(name: "UserListViewController",
                                             bundle: Bundle.main).instantiateViewController(withIdentifier: "UserListViewController") as? UserListViewController else { return false}
    controller.viewModel = userListViewModel
    window?.rootViewController = UINavigationController(rootViewController: controller)
    window?.makeKeyAndVisible()
    return true
  }
}

