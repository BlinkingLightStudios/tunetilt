//
//  ViewController.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 15/5/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    // Data fields
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Sequences1.plist")
    var db: Firestore!
    var newNote = [Song]()
    var storage = SongsStorage()
    
    // Outlet fields
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readNotes()
        styleButton()
    }
    
    func styleButton() {
        playButton.layer.cornerRadius = playButton.frame.width / 2
        playButton.layer.borderColor = UIColor.black.cgColor
        playButton.layer.masksToBounds = true;
    }

    func readNotes(){
        db = Firestore.firestore()
        db.collection("sequences").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    if let notes = document.data()["notes"] as? [String]{
                        if let name = document.data()["name"] as? String {
                        let newItem = Song(id: id, notes: notes, name: name)
                        self.newNote.append(newItem)
                        self.storage.saveData(theNote: self.newNote)
                        }
                    }
                }
            }
        }
    }


}

