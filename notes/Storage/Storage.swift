//
//  Storage.swift
//  notes
//
//  Created by Admin on 19.03.2021.
//

import UIKit
import CoreData

class Storage {
  static let instance = Storage()
  
  private let context: NSManagedObjectContext
  private var saveContext: () -> Void = { () -> Void in }
  
  private init(){
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    context = appDelegate.persistentContainer.viewContext
    saveContext = appDelegate.saveContext
  }
  
  private func createNoteManagedObject(note: Note) -> NoteManagedObject {
    let noteManagedObject = NoteManagedObject(context: context)
    noteManagedObject.id = note.id
    noteManagedObject.content = note.content
    return noteManagedObject
  }
  
  private func createNote(noteManagedObject: NoteManagedObject) -> Note {
    return Note(id: noteManagedObject.id!, content: noteManagedObject.content!)
  }
  
  func saveNote(_ note: Note) {
    let notesRequest: NSFetchRequest<NoteManagedObject> = NoteManagedObject.fetchRequest()
    notesRequest.predicate = NSPredicate(format: "id = %@", note.id as String)
    
    let results = try? context.fetch(notesRequest)
    
    if results?.count == 0 {
      // inserting
      _ = createNoteManagedObject(note: note)
    } else {
      // updating
      let noteManagedObject = results?.first
      noteManagedObject?.content = note.content
    }
    
    saveContext()
  }
  
  func removeNote(_ note: Note) {
    let notesRequest: NSFetchRequest<NoteManagedObject> = NoteManagedObject.fetchRequest()
    notesRequest.predicate = NSPredicate(format: "id = %@", note.id as String)
    
    let results = try? context.fetch(notesRequest)
    
    if results != nil && results!.count > 0 {
      context.delete(results!.first!)
      saveContext()
    }
  }
  
  func loadAllNotes() -> [Note]? {
    let notesRequest:NSFetchRequest<NoteManagedObject> = NoteManagedObject.fetchRequest()
    
    do {
      let notesItems = try context.fetch(notesRequest)
      return notesItems.map {
        createNote(noteManagedObject: $0)
      }
    } catch {
      print("Could not load notes")
      return nil
    }
  }
}
