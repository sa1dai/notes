//
//  NoteViewController.swift
//  notes
//
//  Created by Admin on 18.03.2021.
//

import UIKit

protocol NoteViewControllerDelegate: class {
  func noteViewController(_ controller: NoteViewController, didFinishAdding note: Note)
  func noteViewController(_ controller: NoteViewController, didFinishEditing note: Note, at index: Int)
}

class NoteViewController: UIViewController {
  
  weak var delegate: NoteViewControllerDelegate?
  var noteToEdit: Note?
  var noteToEditIndex: Int?
  
  private var editMode: Bool {
    self.noteToEdit != nil
  }
  
  lazy var noteContentTextView: UITextView = {
    let textView = UITextView()
    textView.isEditable = true
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.textColor = Appearance.primaryColor
    textView.backgroundColor = Appearance.TextField.backgroundColor
    textView.font = UIFont.systemFont(ofSize: 20)
    textView.becomeFirstResponder()
    return textView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = Appearance.secondaryColor
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    self.navigationItem.largeTitleDisplayMode = .never
    self.navigationItem.title = self.editMode
      ? NSLocalizedString("Edit the note", comment: "Edit the note")
      : NSLocalizedString("Create a note", comment: "Create a note")
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.onDonePressed))
    
    if self.editMode {
      self.noteContentTextView.text = noteToEdit!.content
    }
    
    self.view.addSubview(self.noteContentTextView)
    
    NSLayoutConstraint.activate([
      self.noteContentTextView.topAnchor.constraint(equalTo: self.view.readableContentGuide.topAnchor, constant: 20),
      self.noteContentTextView.trailingAnchor.constraint(equalTo: self.view.readableContentGuide.trailingAnchor),
      self.noteContentTextView.leadingAnchor.constraint(equalTo: self.view.readableContentGuide.leadingAnchor),
      self.noteContentTextView.bottomAnchor.constraint(equalTo: self.view.readableContentGuide.bottomAnchor, constant: -20),
    ])
    
  }
  
  // https://www.hackingwithswift.com/example-code/uikit/how-to-adjust-a-uiscrollview-to-fit-the-keyboard
  @objc func adjustForKeyboard(notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    
    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      noteContentTextView.contentInset = .zero
    } else {
      noteContentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    }
    
    noteContentTextView.scrollIndicatorInsets = noteContentTextView.contentInset
    
    let selectedRange = noteContentTextView.selectedRange
    noteContentTextView.scrollRangeToVisible(selectedRange)
  }
  
  @objc func onDonePressed(sender: UIButton!) {
    let noteContent = self.noteContentTextView.text ?? ""
    if (noteContent.isEmptyAfterTrim) {
      self.presentOKAlert(title: self.editMode
                            ? NSLocalizedString("Fail to edit the note. Note content cannot be empty.", comment: "Fail to edit the note. Note content cannot be empty.")
                            : NSLocalizedString("Fail to create the note. Note content cannot be empty.", comment: "Fail to create the note. Note content cannot be empty."))
    } else {
      if self.editMode {
        noteToEdit?.content = noteContent
        self.delegate?.noteViewController(self, didFinishEditing: noteToEdit!, at: self.noteToEditIndex!)
      } else {
        let newNote = Note.createNote(content: noteContent)
        self.delegate?.noteViewController(self, didFinishAdding: newNote)
      }
    }
  }
  
}
