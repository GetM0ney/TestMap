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
    window?.rootViewController = UIStoryboard(name: "UserListViewController", bundle: nil).instantiateInitialViewController()
    window?.makeKeyAndVisible()
    return true
  }
}

