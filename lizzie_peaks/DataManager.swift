//
//  DataManager.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-01.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataManager{
    let context : NSManagedObjectContext!
    let entity :  NSEntityDescription!
    init(){
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "Skill", in: context)
    }
    
    func insertSkill(concept : String, newLearnings : String, oldSkills : String, percentNew : Int, timeLearned : Date, timeSpentLearning : Int) -> Bool{
            let curSkill = NSManagedObject(entity: entity!, insertInto: context)
            curSkill.setValue(concept, forKey: "concept")
            curSkill.setValue(newLearnings, forKey: "newLearnings")
            curSkill.setValue(oldSkills, forKey: "oldSkills")
            curSkill.setValue(percentNew, forKey: "percentNew")
            curSkill.setValue(timeLearned, forKey: "timeLearned")
            curSkill.setValue(timeSpentLearning, forKey: "timeSpentLearning")
        do {
            try context.save()
            NSLog("Successfully saved the current Skill")
            return true
        } catch let error{
            NSLog("Couldn't save: the current Skill with  error: \(error)")
            return false
        }
    }
    func getAllSkills() -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Skill")
        
        do{
            let result = try context.fetch(request)
            return result as! [NSManagedObject]
        } catch let error{
            NSLog("Couldn't load Skill rows with error: \(error)")
            return []
        }
    }
    
    func dropAllRows(){
        // remove MarkEvent rows
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Skill")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do{
            try context.execute(deleteRequest)
            try context.save()
            NSLog("Deleted Skill rows")
        }catch let error{
            NSLog("Couldn't Delete Skill rows with error: \(error)")
        }
    }
}
