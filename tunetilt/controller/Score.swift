//
//  Score.swift
//  tunetilt
//
//  Created by Nicholas Maslen on 2/6/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Score{
    public func save(player: String, score: Double, tune: String){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let rows: [NSManagedObject] = get(tune: tune)
        for row in rows{
            if row.value(forKey: "player") as? String==player{
                let playerscore = row.value(forKey: "score") as! Double
                if playerscore < score{
                    row.setValue(score, forKey: "score")
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    return
                }
                else{
                    return
                }
            }
        }
        let entity =
            NSEntityDescription.entity(forEntityName: "Leaderboards",
                                       in: managedContext)!
        let entry = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        entry.setValue(player, forKeyPath: "player")
        entry.setValue(score, forKeyPath: "score")
        entry.setValue(tune, forKeyPath: "tune")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func get(tune: String) -> [NSManagedObject]{
        var rows: [NSManagedObject] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return rows
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Leaderboards")
        fetchRequest.predicate = NSPredicate(format: "tune = %@", tune)
        let sort = NSSortDescriptor(key: "score", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            rows = try managedContext.fetch(fetchRequest)
            return rows
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return rows
    }
    
    public func getBest(player: String, tune: String) -> Double{
        var rows: [NSManagedObject] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return 0
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Leaderboards")
        fetchRequest.predicate = NSPredicate(format: "tune = %@", tune)
        fetchRequest.predicate = NSPredicate(format: "player = %@", player)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            rows = try managedContext.fetch(fetchRequest)
            return rows[0].value(forKey: score) as! Double
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return 0
    }
    
}

