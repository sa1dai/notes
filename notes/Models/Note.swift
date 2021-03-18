//
//  Note.swift
//  notes
//
//  Created by Admin on 18.03.2021.
//

import Foundation

struct Note {
  let id: String
  var content: String
  
  init(id: String, content: String) {
    self.id = id
    self.content = content
  }
  
  static func createNote(content: String) -> Note {
    return Note(id: UUID().uuidString, content: content)
  }
}
