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
            let reviews = try NSKeyedArchiver.archivedData(withRootObject: skill.scheduledReviews, requiringSecureCoding: false)
            let reviewDurations = try NSKeyedArchiver.archivedData(withRootObject: skill.scheduledReviewDurations, requiringSecureCoding: false)
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
            curSkill.setValue(reviews, forKey: "reviews")
            curSkill.setValue(reviewDurations, forKey: "reviewDurations")
            
            NSLog("Successfully converted skills to coredata entities")
        } catch let error {
            NSLog("Couldn't convert scheduled reviews to binary: \(error)")
        }
    }
    
    func reviewToNSManagedObject(curReview : NSManagedObject, review : ReviewObj){
        curReview.setValue(review.concept, forKey: "concept")
        curReview.setValue(review.dateReviewed, forKey: "dateReviewed")
        curReview.setValue(review.newLearnings, forKey: "newLearnings")
        curReview.setValue(review.reviewDuration, forKey: "reviewDuration")
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
    
    func insertReview(review : ReviewObj){
        let curReview = NSManagedObject(entity: reviewEntity!, insertInto: context)
        reviewToNSManagedObject(curReview : curReview, review : review)
        do {
            try context.save()
            NSLog("Successfully saved the current Review")
        } catch let error{
            NSLog("Couldn't save: the current Review with  error: \(error)")
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
    
    func updateReview(review : ReviewObj){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Review")
        
        fetchRequest.predicate = NSPredicate(format: "dateReviewed = %@",
                                             argumentArray: [review.dateReviewed])
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                reviewToNSManagedObject(curReview: results![0], review : review)
            }
        } catch {
            print("Fetch past reviews for update Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            print("Saving past reviews for update Failed: \(error)")
        }
    }
    
    func getAllEntities(entityName : String, predicate : NSPredicate?) -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if predicate != nil{
            request.predicate = predicate
        }
        
        do{
            let result = try context.fetch(request)
            return result as! [NSManagedObject]
        } catch let error{
            NSLog("Couldn't load Skill rows with error: \(error)")
            return []
        }
    }
    
    func getAllSkills() -> [SkillObj]{
        // TODO: find a way to batch convert these entites
        let entities = getAllEntities(entityName : "Skill", predicate: nil)
        var allEntities : [SkillObj] = []
        for entity in entities{
            
            let scheduledReviewsNSData = entity.value(forKey: "scheduledReviews") as! NSData
            let scheduledReviewDurationsNSData = entity.value(forKey: "scheduledReviewDurations") as! NSData
            let reviewsNSData = entity.value(forKey: "reviews") as! NSData
            let reviewDurationsNSData = entity.value(forKey: "reviewDurations") as! NSData
            
            let scheduledReviewsData = Data(referencing:scheduledReviewsNSData)
            let scheduledReviewDurationsData = Data(referencing:scheduledReviewDurationsNSData)
            let reviewsData = Data(referencing:reviewsNSData)
            let reviewDurationsData = Data(referencing:reviewDurationsNSData)

            do {
                let scheduledReviews = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(scheduledReviewsData) as? Array<Date>
                let scheduledReviewDurations = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(scheduledReviewDurationsData) as? Array<Int>
                let reviews = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(reviewsData) as? Array<Date>
                let reviewDurations = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(reviewDurationsData) as? Array<Int>
                
                allEntities.append(SkillObj(concept : entity.value(forKey: "concept") as! String,
                newLearnings : entity.value(forKey: "newLearnings") as! String,
                oldSkills : entity.value(forKey: "oldSkills") as! String,
                percentNew : entity.value(forKey: "percentNew") as! Int,
                timeLearned : entity.value(forKey: "timeLearned") as! Date,
                timeSpentLearning : entity.value(forKey: "timeSpentLearning") as! Int,
                scheduledReviews : scheduledReviews ?? [],
                scheduledReviewDurations : scheduledReviewDurations ?? [],
                reviews : reviews ?? [],
                reviewDurations : reviewDurations ?? []))
            }catch let error{
                NSLog("couldn't load binary from coredata: \(error)")
            }
        }
        return allEntities
    }
    
    func getAllReviews(timeLearned : Date) -> [ReviewObj]{
        let reviewPredicate = NSPredicate(format: "timeLearned = %@", argumentArray: [timeLearned])
        let entities = getAllEntities(entityName : "Review", predicate: reviewPredicate)
        var allEntities : [ReviewObj] = []
        for entity in entities{
            allEntities.append(ReviewObj(concept : entity.value(forKey: "concept") as! String,
                                        dateReviewed : entity.value(forKey: "dateReviewed") as! Date,
                                        newLearnings : entity.value(forKey: "newLearnings") as! String,
                                        reviewDuration : entity.value(forKey: "reviewDuration") as! Int,
                                        timeLearned : entity.value(forKey: "timeLearned") as! Date))
        }
        return allEntities
    }
    
    func deleteSkill(timeLearned : Date){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Skill")
        fetchRequest.predicate = NSPredicate(format: "timeLearned == %@", argumentArray: [timeLearned])
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do{
            try context.execute(deleteRequest)
            try context.save()
            NSLog("Deleted skill created at: \(timeLearned)")
        }catch let error{
            NSLog("Couldn't delete skill created at \(timeLearned) with error: \(error)")
        }
    }
    
    
    func deleteReview(dateReviewed : Date){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Review")
        fetchRequest.predicate = NSPredicate(format: "dateReviewed == %@", argumentArray: [dateReviewed])
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do{
            try context.execute(deleteRequest)
            try context.save()
            NSLog("Deleted review created at: \(dateReviewed)")
        }catch let error{
            NSLog("Couldn't delete review created at \(dateReviewed) with error: \(error)")
        }
    }
    
    func deleteReviews(timeLearned : Date){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Review")
        fetchRequest.predicate = NSPredicate(format: "timeLearned == %@", argumentArray: [timeLearned])
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do{
            try context.execute(deleteRequest)
            try context.save()
            NSLog("Deleted review created at: \(timeLearned)")
        }catch let error{
            NSLog("Couldn't delete review created at \(timeLearned) with error: \(error)")
        }
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
