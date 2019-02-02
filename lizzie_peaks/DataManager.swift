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
    let skillEntity :  NSEntityDescription!
    let reviewEntity :  NSEntityDescription!
    init(){
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        skillEntity = NSEntityDescription.entity(forEntityName: "Skill", in: context)
        reviewEntity = NSEntityDescription.entity(forEntityName: "Review", in: context)
    }
    
    func insertSkill(skill : SkillObj) -> Bool{
            let curSkill = NSManagedObject(entity: skillEntity!, insertInto: context)
            curSkill.setValue(skill.concept, forKey: "concept")
            curSkill.setValue(skill.newLearnings, forKey: "newLearnings")
            curSkill.setValue(skill.oldSkills, forKey: "oldSkills")
            curSkill.setValue(skill.percentNew, forKey: "percentNew")
            curSkill.setValue(skill.timeLearned, forKey: "timeLearned")
            curSkill.setValue(skill.timeSpentLearning, forKey: "timeSpentLearning")
        do {
            try context.save()
            NSLog("Successfully saved the current Skill")
            return true
        } catch let error{
            NSLog("Couldn't save: the current Skill with  error: \(error)")
            return false
        }
    }
    
    func insertReview(review : ReviewObj) -> Bool{
        let curSkill = NSManagedObject(entity: reviewEntity!, insertInto: context)
        curSkill.setValue(review.concept, forKey: "concept")
        curSkill.setValue(review.lastTimeReviewed, forKey: "lastTimeReviewed")
        curSkill.setValue(review.newLearnings, forKey: "newLearnings")
        curSkill.setValue(review.timesReviewed, forKey: "timesReviewed")
        curSkill.setValue(review.reviewDuration, forKey: "reviewDuration")
        curSkill.setValue(review.scheduledDate, forKey: "scheduledDate")
        curSkill.setValue(review.scheduledDuration, forKey: "scheduledDuration")
        curSkill.setValue(review.timeLearned, forKey: "timeLearned")
        do {
            try context.save()
            NSLog("Successfully saved the current Review")
            return true
        } catch let error{
            NSLog("Couldn't save: the current Review with  error: \(error)")
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
