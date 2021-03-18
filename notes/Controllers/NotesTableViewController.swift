//
//  NotesTableViewController.swift
//  notes
//
//  Created by Admin on 18.03.2021.
//

import UIKit

class NotesTableViewController: UIViewController {
  
  var notes = [Note]()
  private let cellId = "notesCell"
  
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = Appearance.secondaryColor
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    tableView.tableFooterView = UIView() // hide separator between empty cells of UITableView
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = Appearance.secondaryColor
    
    self.navigationItem.title = NSLocalizedString("Notes", comment: "Notes")
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onAddNotePressed))
    
    self.view.addSubview(self.tableView)
    
    NSLayoutConstraint.activate([
      self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
  }
  
  @objc func onAddNotePressed(sender: UIBarButtonItem) {
    self.navigateToNoteViewController()
  }
  
  func navigateToNoteViewController(noteToEdit: Note? = nil, noteToEditIndex: Int? = nil) {
    let noteViewController = NoteViewController()
    noteViewController.delegate = self
    noteViewController.noteToEdit = noteToEdit
    noteViewController.noteToEditIndex = noteToEditIndex
    self.navigationController?.pushViewController(noteViewController, animated: true)
  }
}

extension NotesTableViewController : NoteViewControllerDelegate {
  
  func noteViewController(_ controller: NoteViewController, didFinishAdding note: Note) {
    self.navigationController?.popViewController(animated: true)
    self.notes.append(note)
    Storage.instance.saveNote(note)
    let addedNoteIndex = self.notes.count - 1
    let indexPath = IndexPath(row: addedNoteIndex, section: 0)
    let indexPaths = [indexPath]
    self.tableView.insertRows(at: indexPaths, with: .automatic)
  }
  
  func noteViewController(_ controller: NoteViewController, didFinishEditing note: Note, at index: Int) {
    self.navigationController?.popViewController(animated: true)
    self.notes[index] = note
    Storage.instance.saveNote(note)
    let indexPath = IndexPath(row: index, section: 0)
    if let cell = self.tableView.cellForRow(at: indexPath) {
      cell.textLabel?.text = note.content
    }
  }
  
}

extension NotesTableViewController : UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedNoteIndex = indexPath.row
    let selectedNote = self.notes[selectedNoteIndex]
    self.navigateToNoteViewController(noteToEdit: selectedNote, noteToEditIndex: selectedNoteIndex)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      Storage.instance.removeNote(self.notes[indexPath.row])
      self.notes.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
}

extension NotesTableViewController : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.notes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath as IndexPath)
    let note = self.notes[indexPath.row]
    cell.textLabel?.text = "\(note.content)"
    cell.textLabel?.textColor = Appearance.primaryColor
    cell.backgroundColor = Appearance.secondaryColor
    cell.accessoryType = .disclosureIndicator
    cell.selectionStyle = .none
    return cell
  }
  
}

