//
//  MainNoteViewController.swift
//  SuperDealTest
//
//  Created by Nikolay Dementiev on 21.09.17.
//  Copyright © 2017 mc373. All rights reserved.
//

import UIKit

class MainNoteViewController: UIViewController {

    @IBOutlet weak var notesTableView: UITableView!
    @IBAction func addEditNoteEntityPressed(_ sender: UIBarButtonItem) {

        performSegue(withIdentifier: addEntityName, sender: self)
    }

    private let addEntityName = "addEditEntity"

    typealias notesType = Notes
    fileprivate var notes: [notesType] = []
    fileprivate let coreDataService = CoreDataService()

    fileprivate var lastactiveTableIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        notesTableView.delegate = self
        notesTableView.dataSource = self

        loadNotes()
    }


    //MARK: CoreData func.
    func loadNotes() {
        notes = coreDataService.loadNotes()
        notesTableView.reloadData()
    }

    func addNote(title: String, description: String) {
        coreDataService.addNotes(title: title, description: description)
        loadNotes()
    }

    func updateNote(note: notesType, title: String, description: String) {
        coreDataService.updateTask(note: note, title: title, description: description)
        loadNotes()
    }

    func deleteNote(note: notesType) {
        coreDataService.deleteNotes(note: note)
        loadNotes()
    }


    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addEntityName,
            let destinationVC = segue.destination as? NotesEntityViewController {

            destinationVC.mainNoteDelegate = self

            if let notNullLastactiveTableIndexPath = lastactiveTableIndexPath {
                let notesEntity = notes[notNullLastactiveTableIndexPath.row]
                destinationVC.note = notesEntity
            }
        }
    }
}

//MARK:- TableView Delegate, DataSource
extension MainNoteViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            deleteNote(note: note)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellId = "NotesCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)

        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        }

        let notesEntity = notes[indexPath.row]

        guard let notNullCell = cell else {
            return UITableViewCell()
        }

        notNullCell.textLabel?.text = notesEntity.titleNotes
        notNullCell.detailTextLabel?.text = notesEntity.descriptionNotes

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        lastactiveTableIndexPath = indexPath
    }
}

//MARK:- NotesEntity Protocol
extension MainNoteViewController: NotesEntityViewControllerDelegate {

    func notesListTableViewAddUpdateEntity(note: Notes?, data: NoteListAdditionalData) {

        if let notNullNote =  note {
            updateNote(note: notNullNote, title: data.title, description: data.description)
        } else {
            addNote(title: data.title, description: data.description)
        }

        //update view
        if let notNullIndexPath = lastactiveTableIndexPath,
            let visibleIndexPaths = notesTableView.indexPathsForVisibleRows?.index(of: notNullIndexPath) {
            if visibleIndexPaths != NSNotFound {
                notesTableView.reloadRows(at: [notNullIndexPath], with: .fade)
            }
        }
        
        //erase last index
        notesListTableViewClearLastIndexPath()
    }
    
    func notesListTableViewClearLastIndexPath() {
        lastactiveTableIndexPath = nil
    }
}
