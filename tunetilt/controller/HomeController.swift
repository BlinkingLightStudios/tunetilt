//
//  ViewController.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 15/5/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit
import GameKit

class HomeController: UIViewController, GKGameCenterControllerDelegate {
    
    //Variable that checks if gamecenter is enabled for this session
    var gcEnabled = Bool()
    @IBOutlet weak var playButton: UIButton!
    var player: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = "Guest"
        authenticatePlayer()
        styleButton()
    }
    
    //Function that checks if the GC viewcontroller closed. Required to implement GKGameCenterControllerDelegate
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    }
    
    //Before segue pass the playername through
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="selectSong"){
            guard let SongSelectionController = segue.destination as? SongSelectionController else { return }
            SongSelectionController.player = player
        }
        
    }
    
    func styleButton() {
        playButton.layer.cornerRadius = playButton.frame.width / 2
        playButton.layer.borderColor = UIColor.black.cgColor
        playButton.layer.masksToBounds = true;
    }
    
    //Authenticate the player on startup
    func authenticatePlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        //Start the authentication handler
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            //Show the login screen if no player is logged in to GC on this device
            if((ViewController) != nil) {
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                //If the player was successfully authenticated set the playername to be the logged in players alias
                if let p = localPlayer.alias {
                    self.player = p
                }
                self.gcEnabled = true
            } else {
                //GC is not enabled on this device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
        
        
    }
    
    @IBAction func unwindToHomeController(segue: UIStoryboardSegue) {}
}

