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
    
    
    var gcEnabled = Bool()
    @IBOutlet weak var playButton: UIButton!
    var player: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = "Guest"
        authenticatePlayer()
        styleButton()
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="SongSelect"){
            guard let SongSelectionController = segue.destination as? SongSelectionController else { return }
            SongSelectionController.player = player
        }
        
    }
    func styleButton() {
        playButton.layer.cornerRadius = playButton.frame.width / 2
        playButton.layer.borderColor = UIColor.black.cgColor
        playButton.layer.masksToBounds = true;
    }
    
    func authenticatePlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            //Show the login screen if no player is logged in
            if((ViewController) != nil) {
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                self.gcEnabled = true
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
        
        if let p = localPlayer.alias {
            player = p
        }
    }
    
    @IBAction func unwindToHomeController(segue: UIStoryboardSegue) {}
}

