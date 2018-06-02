//
//  ViewController.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 15/5/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit

class SongSelectionController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Data fields
    var songs = [Song]()
    var selectedSong = Song()
    var buttontext = "Play"
    var player: String?
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Sequences.plist")
    let storage = SongsStorage()
    
    // Outlet fields
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonswitch: UISwitch!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Set up the table view for callbacks
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setup the cell as reusable
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
      
        // Get and set the labels
        let songName: UILabel = cell.viewWithTag(3) as! UILabel
        let difficulty: UILabel = cell.viewWithTag(1) as! UILabel
        let playButton: UIButton = cell.viewWithTag(2) as! UIButton
        let item = songs[indexPath.row]
        songName.text = item.name
        difficulty.text = "Hard"
      
        if (buttonswitch.isOn){
            playButton.setTitle("Play", for: UIControlState())
            
        }
        else{
            playButton.setTitle("Leaderboard", for: UIControlState())
            
        }
//        playButton.setTitle("Play", for: UIControlState())
        
            // Make the background colour alternate
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.1)
        }
        else {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    @IBAction func unwind(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSong = songs[indexPath.row]
        if (!buttonswitch.isOn){
            performSegue(withIdentifier: "Leaderboard", sender: self)
        }
        else{
            performSegue(withIdentifier: "playGame", sender: self)
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="Leaderboard"){
            guard let LeaderboardController = segue.destination as? LeaderboardController else { return }
            LeaderboardController.song = selectedSong.id
        }
        else{
            guard let GameController = segue.destination as? GameController else { return }
            GameController.song = selectedSong
            GameController.player = player
        }
        
    }
    

    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                songs = try decoder.decode([Song].self, from: data)
            }
            catch{
                print("This is \(error)")
            }
        }
    }
    @IBAction func reload(_ sender: Any) {
        tableView.reloadData()
    }
    
}

