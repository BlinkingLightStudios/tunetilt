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
    
    // Outlets
    @IBOutlet weak var songTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songTitleLabel.text = song!.name
    }
    
}
