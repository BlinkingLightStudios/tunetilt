//
//  ViewController.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 15/5/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit

class GameController: UIViewController {
    
    // Fields
    var animatorManager: AnimatorManager?
    
    // Outlets
    @IBOutlet weak var ball: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the animator controller
        animatorManager = AnimatorManager(context: self.view)
        animatorManager!.startGravityUpdates()
        
        animatorManager!.addObject(ball)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

