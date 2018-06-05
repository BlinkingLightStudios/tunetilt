//
//  EndGameController.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 3/6/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit
import Social

class EndGameController: UIViewController {
    
    // Fields
    var song: Song?
    var playerName: String?
    var gameTime: Double?
    
    // Outlets
    @IBOutlet weak var bestTimeLabel: UILabel!
    @IBOutlet weak var playerTimeLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let s = ScoreManager()
        s.save(player: playerName!, score: gameTime!, tune: song!.id)
        
        let roundedPlayerTime = Double(round(1000 * gameTime!)/1000)
        let roundedBestTime = Double(round(1000 * s.getBest(player: playerName!, tune: song!.id))/1000)
        
        songTitleLabel.text = song!.name
        playerTimeLabel.text = "Time: \(roundedPlayerTime)s"
        bestTimeLabel.text = "Best Time: \(roundedBestTime)s"
    }
    
    @IBAction func onHomeClick(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHomeFromEnd", sender: self)
    }
    
    @IBAction func clicktoShare(_ sender: Any) {
        let roundedPlayerTime = Double(round(1000 * gameTime!)/1000)
        let link = "https://blinking-light-studios.github.io/tunetilt/"
        let shareText = "I just played \(song!.name) in \(roundedPlayerTime)s. Play Signature Keys here: \(link)"
        
        let actionSheet = UIAlertController(title: "Share It!", message: "Share your Score.", preferredStyle: .actionSheet)

        let shareFB = UIAlertAction(title: "Share to Facebook", style: .default) { (action) in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
                
                post.setInitialText(shareText)
                
                self.present(post, animated: true, completion: nil)
            }
            else {
                self.showError(service: "Facebook.")
            }
        }
        
        let shareTwitter = UIAlertAction(title: "Share to Twitter", style: .default) { (action) in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                
                post.setInitialText(shareText)
                
                self.present(post, animated: true, completion: nil)
            }
            else {
                self.showError(service: "Twitter.")
            }
        }
        
        let cancelShare = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(shareFB)
        actionSheet.addAction(shareTwitter)
        actionSheet.addAction(cancelShare)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func showError(service: String) {
        let showError = UIAlertController(title: "Error", message: "You are not connected to " + service, preferredStyle: .alert)
        
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        showError.addAction(dismiss)
        present(showError, animated: true, completion: nil)
    }

}
