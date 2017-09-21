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

    typealias notesType = Notes
    fileprivate var notes: [notesType] = []
    fileprivate let coreDataService = CoreDataService()

    fileprivate var lastactiveTableIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        notesTableView.delegate = self
        notesTableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: CoreData func.
    func loadNotes() {
        notes = coreDataService.loadNotes()
        notesTableView.reloadData()
    }

    func addTask(title: String, description: String) {
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if segue.identifier == "addEditEntity" {
            if let destinationVC = segue.destination as? NotesEntityViewController,
                let notNullLastactiveTableIndexPath = lastactiveTableIndexPath {
//                if let notNullLastactiveTableIndexPath = lastactiveTableIndexPath {

                    let notesEntity = notes[notNullLastactiveTableIndexPath.row]
                    destinationVC.noteEntTitle = notesEntity.titleNotes
                    destinationVC.noteEntDescription = notesEntity.descriptionNotes

//
//                    let lastCell = notesTableView.cellForRow(at: notNullLastactiveTableIndexPath)
//
//                    destinationVC.noteEntTitle = lastCell?.textLabel?.text
//                    destinationVC.noteEntDescription = lastCell?.detailTextLabel?.text
//                }

            }
        }
    }
}

extension MainNoteViewController: UITableViewDelegate, UITableViewDataSource
//    , ToDoListTableViewCellDelegate
{

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
