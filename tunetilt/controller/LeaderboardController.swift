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
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var leaderboard: UITableView!
    var song: Song?
    var rows: [NSManagedObject] = []
    let scores = ScoreManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rows = scores.get(tune: song!.id)
        
        headerLabel.text = "Leaderboard for \(song!.name)"
    }

    @IBAction func unwind(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardRow") as! LeaderboardRow
        cell.player.text = row.value(forKey: "player") as? String
        cell.score.text = String(row.value(forKey: "score") as! Double) + "s"
        return cell
    }
    
}

