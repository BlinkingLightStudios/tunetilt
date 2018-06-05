//
//  LeaderboardRow.swift
//  tunetilt
//
//  Created by Nicholas Maslen on 2/6/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit

//Custom class used to reference the rows in the leaderboard table. Contains references to two labels
class LeaderboardRow: UITableViewCell {
    
    @IBOutlet weak var player: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
