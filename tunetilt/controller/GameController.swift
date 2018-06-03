//
//  ViewController.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 15/5/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit
import AudioKit

class GameController: UIViewController, KeyDelegate, SequencePlayerDelegate {
    
    // Constants
    let 🎼 = ["c", "d", "e", "f", "g", "a", "b"]
    
    // Dimensions
    var keySize: CGFloat?
    var allowableX: UInt32?
    var allowableY: UInt32?
    
    // Fields
    var song: Song?
    var sequence: [String] = [String]()
    var playedSequence: [String] = [String]()
    var sequencePlayer: SequencePlayer?
    var player: String?
    
    // Outlet fields
    @IBOutlet weak var playedNotesLabel: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    
    
    @IBAction func onHomeClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onUndoClick(_ sender: UIButton) {
        clearNotes()
        displayNotes()
        playedSequence = [String]()
        updatePlayedNotes()
    }
    
    @IBAction func onReplayClick(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        sequencePlayer!.playSequence()
    }
    
    func clearNotes() {
        for v in self.view.subviews {
            if v.tag >= 100 {
                v.removeFromSuperview()
            }
        }
    }
    
    func displayNotes() {
        for note in sequence {
            addKey(for: note)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the dimensions
        keySize = self.view.bounds.size.width/8
        allowableX = UInt32(self.view.bounds.size.width) - UInt32(keySize!)
        allowableY = UInt32(self.view.bounds.size.height) - UInt32(keySize!)
        
        // Set the sequence
        sequence = song!.notes
        
        // Set up the player
        sequencePlayer = SequencePlayer(sequence: sequence)
        sequencePlayer?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Add the notes to the view
        displayNotes()
    }
    
    func addKey(for note: String) {
        if let key = self.view.viewWithTag(getTag(for: note)) as? Key {
            key.charges += 1
        }
        else {
            // Create the view at a random location in the allowable bounds
            let randPosX = getKeyXPos(for: note)
            let randPosY = getKeyYPos(for: note)
            
            // Create the view at that location
            let key: Key = Key(frame: CGRect(x: randPosX, y: randPosY, width: keySize!, height: keySize!))
            
            // Add field values
            key.setNote(to: note)
            key.delegate = self
            key.tag = getTag(for: note)
            
            // Set up the key for animation
            key.alpha = 0
            key.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            // Add the key to the view
            self.view.addSubview(key)
            
            // Perform the animation on the key
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                key.alpha = 1
                key.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
    
    private func remove(key: Key) {
        // Reduce the charges left
        key.charges -= 1
        if key.charges == 0 {
            // Remove it
            key.removeFromSuperview()
        }
    }
    
    private func getTag(for note: String) -> Int {
        return 🎼.index(of: String(note.first!))! + 100 + (note.last == "#" ? 100 : 0)
    }
    
    func getKeyXPos(for note: String) -> CGFloat {
        let position: Int = 🎼.index(of: String(note.first!))!
        let keyWidth: Float = Float(allowableX!) / 6.0
        let originalPos: Float = Float(keyWidth * position + keyWidth / 2)
        return CGFloat(originalPos - (note.last == "#" ? 0 : keyWidth / 2))
    }
    
    func getKeyYPos(for note: String) -> CGFloat {
        let halfY = allowableY!/2
        let keyHeight: UInt32 = UInt32(keySize! / 2)
        if note.last == "#" {
            var boundedVal = arc4random_uniform(halfY)
            boundedVal += 20
            if boundedVal >= halfY - keyHeight {
                boundedVal -= keyHeight
            }
            return CGFloat(boundedVal)
        }
        else {
            var boundedVal = arc4random_uniform(halfY - keyHeight) + keyHeight
            boundedVal -= 20
            return CGFloat(boundedVal + halfY)
        }
    }
    
    func onKeyTapped(_ key: Key) {
        let note = key.titleLabel!.text!
        do {
            try play(audio: note.lowercased())
            playedSequence.append(note)
            remove(key: key)
            updatePlayedNotes()
            checkWin()
        } catch {
            print("Error playing file")
        }
    }
    
    private func checkWin() {
        if playedSequence.elementsEqual(sequence) {
            performSegue(withIdentifier: "endGame", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="endGame"){
            // Add the values to the new controller
            if let controller = segue.destination as? EndGameController {
                controller.song = song
            }
        }
        
    }
    
    func play(audio: String) throws {
        let audioFile = try AKAudioFile(readFileName: "\(audio).mp3")
        
        let samplePlayer = AKSamplePlayer(file: audioFile)
        
        AudioKit.output = samplePlayer
        try AudioKit.start()
        
        samplePlayer.play(from: Sample(44_100 * (0 % 26)),
                          length: Sample(44_100))
    }
    
    func updatePlayedNotes() {
        playedNotesLabel.text = playedSequence.joined(separator: ", ")
    }
    
    func onItemPlayed(index: Int) {
        replayButton.setTitle("Note \(index)", for: .normal)
    }
    
    func onSequenceEnd() {
        replayButton.setTitle("Replay", for: .normal)
        self.view.isUserInteractionEnabled = true
    }

}

