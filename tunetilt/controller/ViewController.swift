//
//  ViewController.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 15/5/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit
import Firebase
import GameKit
class ViewController: UIViewController, GKGameCenterControllerDelegate {
    var gcEnabled = Bool()
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Sequences1.plist")
//    var Thenote = [String : Array<Any>]()
//    var a = [AnyObject]()
    var db: Firestore!
    var newNote = [Song]()
    var storage = SongsStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticatePlayer()
        readNotes()
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func authenticatePlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            //Show the login screen if no player is logged in
            if((ViewController) != nil) {
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                self.gcEnabled = true
                print(localPlayer.alias!)
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
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

