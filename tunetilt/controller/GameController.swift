//
//  ViewController.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 15/5/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit
import AudioKit

let 🎼 = "hi"

class GameController: UIViewController {
    
    // Outlets

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onKeyTapped(_ sender: UIButton) {
        let note: String = sender.titleLabel!.text!.lowercased()
        
        do {
            try play(audio: getAudioFile(for: note))
        } catch {
            print("error playing file")
        }
    }
    
    func play(audio: String) throws {
        let audioFile = try AKAudioFile(readFileName: "\(audio).mp3")
        
        let samplePlayer = AKSamplePlayer(file: audioFile)
        
        samplePlayer
        
        AudioKit.output = samplePlayer
        try AudioKit.start()
        
        samplePlayer.play(from: Sample(44_100 * (0 % 26)),
                          length: Sample(44_100))
    }
    
    func getAudioFile(for note: String) -> String {
        return note.lowercased()
    }

}

