//
//  SongsLoader.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 4/6/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import Foundation
import Firebase

class SongsLoader {
    
    // Fields
    weak var delegate: SongsLoaderDelegate?
    var db: Firestore!
    var newNote = [Song]()
    var storage = SongsStorage()
    
    func fetch() {
        db = Firestore.firestore()
        db.collection("sequences").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    if let notes = document.data()["notes"] as? [String], let name = document.data()["name"] as? String {
                        
                        let newItem = Song(id: id, notes: notes, name: name)
                        self.newNote.append(newItem)
                        self.storage.saveData(theNote: self.newNote)
                        
                        self.loadContent()
                    }
                }
            }
        }
    }
    
    func loadContent() {
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Sequences.plist")
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                let songs: [Song] = try decoder.decode([Song].self, from: data)
                delegate?.onSongsLoaded(songs: songs)
            }
            catch {
                print("Can't Load Data \(error)")
            }
        }
    }
}

// The SongsLoader delegate protocol
protocol SongsLoaderDelegate: AnyObject {
    func onSongsLoaded(songs: [Song])
}
