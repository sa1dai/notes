//
//  UIViewControllerExtension.swift
//  notes
//
//  Created by Admin on 19.03.2021.
//

import UIKit

extension UIViewController {
  
  func presentOKAlert(title: String) {
    let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "ОК", style: UIAlertAction.Style.cancel))
    self.present(alert, animated: true, completion: nil)
  }
  
}
