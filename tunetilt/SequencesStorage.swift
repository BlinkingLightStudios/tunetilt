//
//  SequencesStorage.swift
//  tunetilt
//
//  Created by Nguyễn Ngọc Anh on 17/5/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import Foundation

class SequencesStorage {

    var note = Notes()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Sequences.plist")
    
    
    func saveData(theNote: Notes){
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
    
    func loadData()  {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                note = try decoder.decode(Notes.self, from: data)
            }
            catch{
                print("Error loading data \(error)")
            }
        }
 }
    
}

