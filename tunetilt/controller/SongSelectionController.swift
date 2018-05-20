//
//  ViewController.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 15/5/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit

class SongSelectionController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Outlet fields
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the table view for callbacks
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setup the cell as reusable
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        
        // Get and set the labels
        let songName: UILabel = cell.viewWithTag(3) as! UILabel
        let difficulty: UILabel = cell.viewWithTag(1) as! UILabel
        let playButton: UIButton = cell.viewWithTag(2) as! UIButton
        songName.text = "A Song Name"
        difficulty.text = "Hard"
        playButton.setTitle("Play", for: UIControlState())
        
        // Make the background colour alternate
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.1)
        }
        else {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }

}

