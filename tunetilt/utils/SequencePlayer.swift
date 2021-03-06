//
//  sequencePlayer.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 3/6/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import Foundation
import AudioKit

class SequencePlayer {

    // Fialds
    let sequence: [String]
    var counter = -1
    var timer = Timer()
    weak var delegate: SequencePlayerDelegate?
    
    init(sequence: [String]) {
        self.sequence = sequence
    }
    
    func playSequence() {
        // Reset the timer
        timer.invalidate()

        // Start a new timer
        timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    
    @objc func timerAction() throws {
        // Increment the counter
        counter += 1
        
        if counter < sequence.count {
            // Play the note
            let note = sequence[counter].lowercased()
            try play(audio: note)
            delegate?.onItemPlayed(index: counter + 1)
        }
        else {
            // End the sequence player
            timer.invalidate()
            counter = -1
            delegate?.onSequenceEnd()
        }
    }
    
    // Plays the note
    private func play(audio: String) throws {
        let audioFile = try AKAudioFile(readFileName: "\(audio).mp3")
        
        let samplePlayer = AKSamplePlayer(file: audioFile)
        
        AudioKit.output = samplePlayer
        try AudioKit.start()
        
        samplePlayer.play(from: Sample(44_100 * (0 % 26)),
                          length: Sample(44_100))
    }
    
}

// The pong's delegate protocol
protocol SequencePlayerDelegate: AnyObject {
    func onItemPlayed(index: Int)
    func onSequenceEnd()
}
