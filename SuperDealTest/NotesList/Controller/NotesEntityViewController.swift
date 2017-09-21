//
//  NotesEntityViewController.swift
//  SuperDealTest
//
//  Created by Nikolay Dementiev on 21.09.17.
//  Copyright © 2017 mc373. All rights reserved.
//

import UIKit

protocol NotesEntityViewControllerDelegate {
    func notesListTableViewAddUpdateEntity(note: Notes?, data: NoteListAdditionalData)
    func notesListTableViewClearLastIndexPath()
}

class NotesEntityViewController: UIViewController {

    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteDescription: UITextField!
    var mainNoteDelegate: NotesEntityViewControllerDelegate?

    var note: Notes?

    private var noteEntTitle: String? {
        get {return self.noteTitle?.text ?? "???"}
        set {self.noteTitle?.text = newValue}
    }
    private var noteEntDescription: String? {
        get {return self.noteDescription?.text ?? "???"}
        set {self.noteDescription?.text = newValue}
    }
    private func updateDataFromModel() {
        noteEntTitle = note?.titleNotes
        noteEntDescription = note?.descriptionNotes
    }

    @IBAction func saveButton(_ sender: UIButton) {
        saveData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateDataFromModel()
        title = NSLocalizedString((note == nil ? "Create" : "Edit"), comment: "") + " " + NSLocalizedString("note", comment: "")
    }

    override func didMove(toParentViewController parent: UIViewController?) {

        if (!(parent?.isEqual(self.parent) ?? false)) {
            self.mainNoteDelegate?.notesListTableViewClearLastIndexPath()
        }
    }

    fileprivate func saveData() {
        guard let notNullNoteEntTitle = noteEntTitle,
            let notNullNoteEntDescription = noteEntDescription else {
                print(NSLocalizedString("An error ocured with", comment: "") + "saveData()!")
                return
        }

        let tempData =  NoteListAdditionalData (title: notNullNoteEntTitle,
                                                description: notNullNoteEntDescription)
        self.mainNoteDelegate?.notesListTableViewAddUpdateEntity(note: note, data: tempData)

        performSegueToReturnBack()
    }
}
