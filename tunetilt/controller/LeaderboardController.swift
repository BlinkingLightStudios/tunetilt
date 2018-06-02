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
    
    @IBOutlet weak var leaderboard: UITableView!
    var song: Song?
    var rows: [NSManagedObject] = []
    let scores = Score()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rows = scores.get(tune: song)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardRows") as! LeaderboardRow
        cell.player.text = row.value(forKey: "player") as? String
        cell.score.text = row.value(forKey: "score") as? String
        print(row.value(forKey: "score")!)
        return cell
    }
    
}

