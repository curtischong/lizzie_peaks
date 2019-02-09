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
    
    func skillToNSManagedObject(curSkill : NSManagedObject, skill : SkillObj){
        do {
            let scheduledReviews = try NSKeyedArchiver.archivedData(withRootObject: skill.scheduledReviews, requiringSecureCoding: false)
            let scheduledReviewDurations = try NSKeyedArchiver.archivedData(withRootObject: skill.scheduledReviewDurations, requiringSecureCoding: false)
            // let scheduledReviews = NSKeyedArchiver.archivedData(withRootObject: )
            //let scheduledReviewDurations = NSKeyedArchiver.archivedData(withRootObject: skill.scheduledReviewDurations)
            
            curSkill.setValue(skill.concept, forKey: "concept")
            curSkill.setValue(skill.newLearnings, forKey: "newLearnings")
            curSkill.setValue(skill.oldSkills, forKey: "oldSkills")
            curSkill.setValue(skill.percentNew, forKey: "percentNew")
            curSkill.setValue(skill.timeLearned, forKey: "timeLearned")
            curSkill.setValue(skill.timeSpentLearning, forKey: "timeSpentLearning")
            curSkill.setValue(scheduledReviews, forKey: "scheduledReviews")
            curSkill.setValue(scheduledReviewDurations, forKey: "scheduledReviewDurations")
            
            NSLog("Successfully converted skills to coredata entities")
        } catch let error {
            NSLog("Couldn't convert scheduled reviews to binary: \(error)")
        }
    }
    
    func reviewToNSManagedObject(curReview : NSManagedObject, review : ReviewObj){
        curReview.setValue(review.concept, forKey: "concept")
        curReview.setValue(review.lastTimeReviewed, forKey: "lastTimeReviewed")
        curReview.setValue(review.newLearnings, forKey: "newLearnings")
        curReview.setValue(review.timesReviewed, forKey: "timesReviewed")
        curReview.setValue(review.reviewDuration, forKey: "reviewDuration")
        curReview.setValue(review.scheduledDate, forKey: "scheduledDate")
        curReview.setValue(review.scheduledDuration, forKey: "scheduledDuration")
        curReview.setValue(review.timeLearned, forKey: "timeLearned")
    }
    
    
    func insertSkill(skill : SkillObj){
        let curSkill = NSManagedObject(entity: skillEntity!, insertInto: context)
        skillToNSManagedObject(curSkill : curSkill, skill : skill)
        do {
            try context.save()
            NSLog("Successfully saved the current Skill")
        } catch let error{
            NSLog("Couldn't save: the current Skill with  error: \(error)")
        }
    }
    
    func insertReview(review : ReviewObj) -> Bool{
        let curReview = NSManagedObject(entity: reviewEntity!, insertInto: context)
        reviewToNSManagedObject(curReview : curReview, review : review)
        do {
            try context.save()
            NSLog("Successfully saved the current Review")
            return true
        } catch let error{
            NSLog("Couldn't save: the current Review with  error: \(error)")
            return false
        }
    }
    
    func updateSkill(skill : SkillObj){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Skill")
        
        fetchRequest.predicate = NSPredicate(format: "timeLearned = %@",
                                             argumentArray: [skill.timeLearned])
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                skillToNSManagedObject(curSkill: results![0], skill : skill)
            }
        } catch {
            print("Fetch past skills for update Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            print("Saving past skills for update Failed: \(error)")
        }
    }
    
    func getAllEntities(entityName : String) -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do{
            let result = try context.fetch(request)
            return result as! [NSManagedObject]
        } catch let error{
            NSLog("Couldn't load Skill rows with error: \(error)")
            return []
        }
    }
    
    func getAllSkills(entityName : String) -> [SkillObj]{
        // TODO: find a way to batch convert these entites
        let entities = getAllEntities(entityName : entityName)
        var allEntities : [SkillObj] = []
        for entity in entities{
            
            let reviewsNSData = entity.value(forKey: "scheduledReviews") as! NSData
            let reviewDurationsNSData = entity.value(forKey: "scheduledReviewDurations") as! NSData
            
            let reviewsData = Data(referencing:reviewsNSData)
            let reviewDurationsData = Data(referencing:reviewDurationsNSData)

            do {
                let scheduledReviews = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(reviewsData) as? Array<Date>
                let scheduledReviewDurations = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(reviewDurationsData) as? Array<Int>
                
                allEntities.append(SkillObj(concept : entity.value(forKey: "concept") as! String,
                newLearnings : entity.value(forKey: "newLearnings") as! String,
                oldSkills : entity.value(forKey: "oldSkills") as! String,
                percentNew : entity.value(forKey: "percentNew") as! Int,
                timeLearned : entity.value(forKey: "timeLearned") as! Date,
                timeSpentLearning : entity.value(forKey: "timeSpentLearning") as! Int,
                scheduledReviews : scheduledReviews ?? [],
                scheduledReviewDurations : scheduledReviewDurations ?? []))
            }catch let error{
                NSLog("couldn't load binary from coredata: \(error)")
            }
        }
        return allEntities
    }
    
    func dropSkillRows(){
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
    
    func dropReviewRows(){
        // remove MarkEvent rows
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Review")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do{
            try context.execute(deleteRequest)
            try context.save()
            NSLog("Deleted Review rows")
        }catch let error{
            NSLog("Couldn't Delete Review rows with error: \(error)")
        }
    }
    
    func dropAllRows(){
        dropSkillRows()
        dropReviewRows()
    }
}
