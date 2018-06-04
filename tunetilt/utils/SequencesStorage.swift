//
//  SequencesStorage.swift
//  tunetilt
//
//  Created by Nguyễn Ngọc Anh on 17/5/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import Foundation

class SongsStorage {

    var note = Song()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Sequences.plist")
    
    
    func saveData(theNote: [Song]){
        let encoder = PropertyListEncoder()
        do{
            print(dataFilePath!)
            let data = try encoder.encode(theNote)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Error saving data \(error)")
        }
    }

    
}

