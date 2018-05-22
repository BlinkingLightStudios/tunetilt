//
//  ViewController.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 15/5/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    var db: Firestore!
    var newNote = Notes()
    var storage = SequencesStorage()
    override func viewDidLoad() {
        super.viewDidLoad()
        readNotes()
        // Do any additional setup after loading the view, typically from a nib.
    }
override func viewDidDisappear(_ animated: Bool) {
    storage.loadData()
    print("The sequences is \(self.newNote.notes)")
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func readNotes(){
        db = Firestore.firestore()
        db.collection("sequences").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let name = document.data()["notes1"] as? [String] {
                        self.newNote.notes = name
                        self.storage.saveData(theNote: self.newNote)
                    }
                }
            }
        }
        
    }

}

