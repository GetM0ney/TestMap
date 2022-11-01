//
//  NSDate.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 1.11.22.
//

import Foundation

extension Date {
  func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
    return calendar.dateComponents(Set(components), from: self)
  }
  
  func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
    return calendar.component(component, from: self)
  }
  
  func getDayMonthString() -> String? {
    let components = get(.day,.month)
    guard let day = components.day, let month = components.month else { return nil }
    return "\(day).\(month)"
  }
}
