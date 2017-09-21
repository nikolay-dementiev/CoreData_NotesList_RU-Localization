//
//  File.swift
//  SuperDealTest
//
//  Created by Nikolay Dementiev on 21.09.17.
//  Copyright © 2017 mc373. All rights reserved.
//

import CoreData
import UIKit

class CoreDataService {

    var context: NSManagedObjectContext

    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

    private func save() {
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    func loadNotes() -> [Notes] {
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        var Notess: [Notes]?

        do {
            Notess = try context.fetch(fetchRequest)
        } catch {
            print("Error with request: \(error)")
        }

        return Notess!
    }

    func addNotes(title: String, description: String) {
        if let entity = NSEntityDescription.entity(forEntityName: String(describing: Notes.self), in: context) {

            if let notesEnt = NSManagedObject(entity: entity, insertInto: context) as? Notes {
                updateTask(note: notesEnt, title: title, description: description)
            }
        }
    }

    func updateTask(note notesEnt: Notes, title: String, description: String) {

        notesEnt.setValue(title, forKey: "titleNotes")
        notesEnt.setValue(description, forKey: "descriptionNotes")

        save()
    }

    func deleteNotes(note: Notes) {
        context.delete(note)

        save()
    }
    
}
