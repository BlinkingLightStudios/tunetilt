//
//  LeaderboardController.swift
//  tunetilt
//
//  Created by Nicholas Maslen on 2/6/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit
import CoreData

class LeaderboardController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //Variables for the leaderboard
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var leaderboard: UITableView!
    var song: Song?
    var rows: [NSManagedObject] = []
    let scores = ScoreManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get the scores from CoreData based on the song id
        rows = scores.get(tune: song!.id)
        
        headerLabel.text = "Leaderboard for \(song!.name)"
    }

    //Return to previous screen
    @IBAction func unwind(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Number of rows for the table is set to the number of rows retreived from CoreData
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    //Set the labels in the leaderboard to be the player and scores retreived from CoreData
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardRow") as! LeaderboardRow
        cell.player.text = row.value(forKey: "player") as? String
        cell.score.text = String(row.value(forKey: "score") as! Double) + "s"
        return cell
    }
    
}

