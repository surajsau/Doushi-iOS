//
//  Verb.swift
//  Doushi
//
//  Created by Suraj Sau on 02/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import Foundation
import RealmSwift
import CoreData

class Verb: Object {
    @objc dynamic var firstForm: String? = nil
    @objc dynamic var secondForm: String? = nil
    @objc dynamic var reading: String? = nil
    @objc dynamic var romaji: String? = nil
    @objc dynamic var firstVerb: String? = nil
    @objc dynamic var firstVerbReading: String? = nil
    @objc dynamic var firstVerbRomaji: String? = nil
    @objc dynamic var firstVerbMasu: String? = nil
    @objc dynamic var firstVerbMasuReading: String? = nil
    @objc dynamic var firstVerbMasuRomaji: String? = nil
    @objc dynamic var secondVerb: String? = nil
    @objc dynamic var secondVerbReading: String? = nil
    @objc dynamic var secondVerbRomaji: String? = nil
    @objc dynamic var transitive: String? = nil
    @objc dynamic var usagePattern: String? = nil
    @objc dynamic var seeAlso: String? = nil
    @objc dynamic var pronounce: String? = nil
    @objc dynamic var noun: String? = nil
    @objc dynamic var synonymn: String? = nil
    @objc dynamic var antonym: String? = nil
    @objc dynamic var remarks: String? = nil
    
    let meanings = List<Meaning>()
    
    @objc var nlbLink: String? = nil
}

class Meaning: Object {
    @objc dynamic var language: String? = nil
    @objc dynamic var meaning: String? = nil
    @objc dynamic var example: String? = nil
    @objc dynamic var reading: String? = nil
}

struct VerbHistory {
    let verbReading: String
    let timeStamp: Double
    let times: Int
}

struct VerbFavorite {
    let verbReading: String
    let timeStamp: Double
}

class LocalData {
    
    let searchModes = [SearchMode.Combined, SearchMode.FirstVerb, SearchMode.SecondVerb]
    
    private lazy var managecContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistenContainer.viewContext
    }()
    
    func upsert(history object: VerbHistory) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        fetchRequest.predicate = NSPredicate(format: "verbReading == %@", object.verbReading)
        
        do {
            let fetchResult = try managecContext.fetch(fetchRequest) as! [NSManagedObject]
            
            if fetchResult.count == 1 {
                let times = fetchResult[0].value(forKey: "times") as? Int ?? 0
                save(history: VerbHistory(verbReading: object.verbReading, timeStamp: object.timeStamp, times: times + 1))
            } else {
                save(history: object)
            }
            
        } catch let error as NSError {
            print("Error while upserting history: \(error.userInfo)")
        }
    }
    
    func delete(favorite object: VerbFavorite) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "verbReading == %@", object.verbReading)
        
        do {
            let fetchResult = try managecContext.fetch(fetchRequest) as! [NSManagedObject]
            if fetchResult.count == 1 {
                managecContext.delete(fetchResult[0])
            }
            
        } catch let error as NSError {
            print("Error while deleting favorite: \(error.userInfo)")
        }
    }
    
    private func save(history object: VerbHistory) {
        let entity = NSEntityDescription.entity(forEntityName: "History", in: managecContext)!
        let history = NSManagedObject(entity: entity, insertInto: managecContext)
        
        history.setValue(object.verbReading, forKey: "verbReading")
        history.setValue(object.timeStamp, forKey: "timeStamp")
        history.setValue(object.times, forKey: "times")
        
        do {
            try managecContext.save()
        } catch let error as NSError {
            print("Error while saving history: \(error.userInfo)")
        }
    }
    
    private func save(favorite object: VerbFavorite) {
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managecContext)!
        let favorite = NSManagedObject(entity: entity, insertInto: managecContext)
        
        favorite.setValue(object.verbReading, forKey: "verbReading")
        favorite.setValue(object.timeStamp, forKey: "timeStamp")
        
        do {
            try managecContext.save()
        } catch let error as NSError {
            print("Error while saving favorite: \(error.userInfo)")
        }
    }
    
    func fetch() -> [VerbHistory] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        
        var result: [VerbHistory] = []
        
        do {
            let fetch = try managecContext.fetch(fetchRequest)
            for data in fetch as! [NSManagedObject] {
                let object = VerbHistory(verbReading: data.value(forKey: "verbReading") as? String ?? "",
                                         timeStamp: data.value(forKey: "timeStamp") as? Double ?? 0,
                                         times: data.value(forKey: "times") as? Int ?? 0)
                result.append(object)
            }
        } catch let error as NSError {
            print("Error while fetching History: \(error.userInfo)")
        }
        
        return result
    }
    
    func fetch() -> [VerbFavorite] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        
        var result: [VerbFavorite] = []
        
        do {
            let fetch = try managecContext.fetch(fetchRequest)
            for data in fetch as! [NSManagedObject] {
                let object = VerbFavorite(verbReading: data.value(forKey: "verbReading") as? String ?? "",
                                         timeStamp: data.value(forKey: "timeStamp") as? Double ?? 0)
                result.append(object)
            }
        } catch let error as NSError {
            print("Error while fetching History: \(error.userInfo)")
        }
        
        return result
    }
    
}
