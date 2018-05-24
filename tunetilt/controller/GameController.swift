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
    
    // Fields
    let songId: String? = "1987429870976"
    let sequence: [String]? = ["a", "b", "c", "a#"]
    
    // Outlets
    @IBOutlet weak var stack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let notes: [String] = sequence {
            for note in notes {
                let button: UIButton = UIButton()
                button.titleLabel?.text = note
                button.setTitle(note, for: .normal)
                button.addTarget(self, action: #selector(onKeyTapped(_:)), for: .touchUpInside)
                button.backgroundColor = UIColor.black
                stack.addArrangedSubview(button)
            }
        }
    }
    
    @IBAction @objc func onKeyTapped(_ sender: UIButton) {
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
        
        AudioKit.output = samplePlayer
        try AudioKit.start()
        
        samplePlayer.play(from: Sample(44_100 * (0 % 26)),
                          length: Sample(44_100))
    }
    
    func getAudioFile(for note: String) -> String {
        return note.lowercased()
    }

}

