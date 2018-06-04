//
//  EndGameController.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 3/6/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit

class EndGameController: UIViewController {
    
    // Fields
    var song: Song?
    var gameTime: Double?
    
    // Outlets
    @IBOutlet weak var playerTimeLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let roundedTime = Double(round(1000 * gameTime!)/1000)
        
        songTitleLabel.text = song!.name
        playerTimeLabel.text = "Time: \(roundedTime)s"
    }
    

}
