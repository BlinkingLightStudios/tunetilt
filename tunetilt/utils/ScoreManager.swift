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

//Class for storing and retreiving data from the CoreData model
class ScoreManager {

    //Create a persistentContainer variable for accessing the CoreData model and the Leaderboard entity
    lazy var persistentContainer: NSPersistentContainer = {
        //Name of the CoreData model is TuneTilt
        let container = NSPersistentContainer(name: "TuneTilt")
        //Try loading the container and print the error if unsuccessful
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    //Function to save new scores to CoreData
    public func save(player: String, score: Double, tune: String){
        let managedContext =
            persistentContainer.viewContext
        //First grab the rows for the given song and loop through them to check if a score already exists for that player and song
        let rows: [NSManagedObject] = get(tune: tune)
        for row in rows{
            //If the player in this row matches the player given, and the score given is lower, then update this row
            //with the new score
            if row.value(forKey: "player") as? String==player{
                let playerscore = row.value(forKey: "score") as! Double
                if playerscore > score{
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
        //If a score for that song and player does not already exist, add a new row in the model for the Leaderboard entity
        let entity =
            NSEntityDescription.entity(forEntityName: "Leaderboards",
                                       in: managedContext)!
        let entry = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        //Set the values of the new row
        entry.setValue(player, forKeyPath: "player")
        entry.setValue(score, forKeyPath: "score")
        entry.setValue(tune, forKeyPath: "tune")
        //Save the new row
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //Function that gets all players and scores for a given song
    public func get(tune: String) -> [NSManagedObject]{
        var rows: [NSManagedObject] = []
        
        let managedContext =
            persistentContainer.viewContext
        //Set up the fetch request with a predicate to filter the results by song
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Leaderboards")
        fetchRequest.predicate = NSPredicate(format: "tune = %@", tune)
        //Apply a sort on the fetch request by score. The lower the score the better
        let sort = NSSortDescriptor(key: "score", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        //Grab the rows according to this predicate and sort and return them
        do {
            rows = try managedContext.fetch(fetchRequest)
            return rows
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return rows
    }
    
    //Funtion that returns an players best score for a song
    public func getBest(player: String, tune: String) -> Double {
        let managedContext =
            persistentContainer.viewContext
        //Create the fetch request with a predicate to filter the results
        //Filter is by both song and player so only one result should be returned
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Leaderboards")
        fetchRequest.predicate = NSPredicate(format: "tune = %@ AND player = %@", tune, player)
        //Return the result if there was one. If the result set was empty then return -1
        do {
            let rows: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            if (rows.count > 0){
                return rows[0].value(forKey: "score") as! Double
            }
            else{
                return -1
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return 0
    }
    
}

