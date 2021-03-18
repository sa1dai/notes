//
//  StringExtension.swift
//  notes
//
//  Created by Admin on 19.03.2021.
//

extension String {
  
  // source: https://stackoverflow.com/a/56071981
  func trim() -> String {
    return self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  var isEmptyAfterTrim: Bool {
    self.trim().isEmpty
  }
  
}
