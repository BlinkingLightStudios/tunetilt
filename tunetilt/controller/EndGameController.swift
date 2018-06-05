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
    var shareText: String?
    
    // Outlets
    @IBOutlet weak var bestTimeLabel: UILabel!
    @IBOutlet weak var playerTimeLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Save the player score
        let s = ScoreManager()
        s.save(player: playerName!, score: gameTime!, tune: song!.id)
        
        // Format the scores
        let roundedPlayerTime = Double(round(1000 * gameTime!)/1000)
        let roundedBestTime = Double(round(1000 * s.getBest(player: playerName!, tune: song!.id))/1000)
        
        // Set the labels
        songTitleLabel.text = song!.name
        playerTimeLabel.text = "Time: \(roundedPlayerTime)s"
        bestTimeLabel.text = "Best Time: \(roundedBestTime)s"
        
        // Set the share text
        let link = "https://blinking-light-studios.github.io/tunetilt/"
        shareText = "I just played \(song!.name) in \(roundedPlayerTime)s. Play Signature Keys here: \(link)"
    }
    
    @IBAction func onHomeClick(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHomeFromEnd", sender: self)
    }
    
    @IBAction func clicktoShare(_ sender: Any) {
        // Create the action sheet
        let actionSheet = UIAlertController(title: "Share It!", message: "Share your Score.", preferredStyle: .actionSheet)

        // Set up the social sources
        let shareFB = getSocial(title: "Share to Facebook", serviceType: SLServiceTypeFacebook, errorService: "Facebook.")
        let shareTwitter = getSocial(title: "Share to Twitter", serviceType: SLServiceTypeTwitter, errorService: "Twitter.")
        let cancelShare = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add them to the action sheet
        actionSheet.addAction(shareFB)
        actionSheet.addAction(shareTwitter)
        actionSheet.addAction(cancelShare)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func getSocial(title: String, serviceType: String, errorService: String) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default) { (action) in
            
            if SLComposeViewController.isAvailable(forServiceType: serviceType) {
                let post = SLComposeViewController(forServiceType: serviceType)!
                
                post.setInitialText(self.shareText!)
                
                self.present(post, animated: true, completion: nil)
            }
            else {
                self.showError(service: errorService)
            }
        }
    }
    
    func showError(service: String) {
        let showError = UIAlertController(title: "Error", message: "You are not connected to " + service, preferredStyle: .alert)
        
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        showError.addAction(dismiss)
        present(showError, animated: true, completion: nil)
    }

}
