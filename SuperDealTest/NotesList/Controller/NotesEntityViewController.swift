//
//  NotesEntityViewController.swift
//  SuperDealTest
//
//  Created by Nikolay Dementiev on 21.09.17.
//  Copyright © 2017 mc373. All rights reserved.
//

import UIKit

class NotesEntityViewController: UIViewController {

    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteDescription: UITextField!

    var noteEntTitle: String? {
        get {return self.noteTitle.text ?? "???"}
        set {self.noteTitle.text = newValue}
    }
    var noteEntDescription: String? {
        get {return self.noteDescription.text ?? "???"}
        set {self.noteDescription.text = newValue}
    }

    @IBAction func saveButton(_ sender: UIButton) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
