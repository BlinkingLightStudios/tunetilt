//
//  ViewController.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 15/5/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit
import AudioKit

class GameController: UIViewController, KeyDelegate {
    
    // Constants
    let 🎼 = ["c", "d", "e", "f", "g", "a", "b"]
    var player: String?
    // Dimensions
    var keySize: CGFloat?
    var allowableX: UInt32?
    var allowableY: UInt32?
    
    // Fields
    var song: Song?
    var sequence: [String] = [String]()
    var playedSequence: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the dimensions
        keySize = self.view.bounds.size.width/8
        allowableX = UInt32(self.view.bounds.size.width) - UInt32(keySize!)
        allowableY = UInt32(self.view.bounds.size.height) - UInt32(keySize!)
        
        sequence = song!.notes
        for note in sequence {
            addKey(for: note)
        }
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
            
            // Add the pong as a subview and register it up with the animator
            self.view.addSubview(key)
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
            if boundedVal >= halfY {
                boundedVal -= keyHeight
            }
            return CGFloat(boundedVal)
        }
        else {
            let boundedVal = arc4random_uniform(halfY - keyHeight) + keyHeight
            return CGFloat(boundedVal + halfY)
        }
    }
    
    func onKeyTapped(_ key: Key) {
        let note = key.titleLabel!.text!
        do {
            try play(audio: note.lowercased())
            playedSequence.append(note)
            remove(key: key)
            checkWin()
        } catch {
            print("Error playing file")
        }
    }
    
    private func checkWin() {
        if playedSequence.elementsEqual(sequence) {
            print("GAME IS WON")
            let _ = Score()
           // s.save(player: player, score: <#T##Double#>, tune: <#T##String#>)
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

}

