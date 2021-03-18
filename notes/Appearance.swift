//
//  Appearance.swift
//  notes
//
//  Created by Admin on 18.03.2021.
//

import UIKit

enum Appearance {
  static let primaryColor = UIColor.white
  static let secondaryColor = UIColor.black
  enum NavigationBar {
    static let barStyle = UIBarStyle.black
    static let barTintColor = UIColor.black
    static let tintColor = UIColor.systemTeal
    static let titleTextAttributes = UIColor.white
    static let largeTitleTextAttributes = UIColor.white
    static let prefersLargeTitles = true
  }
  enum TextField {
    static let backgroundColor = UIColor(red: 0.18, green: 0.17, blue: 0.22, alpha: 1.0)
  }
  enum Button {
    static let textColor = UIColor.black
    static let backgroundColor = UIColor(red: 0.98, green: 0.64, blue: 0.24, alpha: 1.0)
  }
}
