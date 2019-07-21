//
//  SkillObj.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-02.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import Foundation

// Note: We identify mathing reviews based on the timeLearned attribute
class SkillObj{
    var concept : String = ""
    var newLearnings : String = ""
    var oldSkills : String = ""
    var percentNew : Int = 0
    var timeLearned : Date
    var timeSpentLearning : Int = 0
    var scheduledReviews : [Date] = []
    var scheduledReviewDurations : [Int] = []
    var reviews : [Date] = []
    var reviewDurations : [Int] = [] // would be useful when showing total time reviewed
    var uploaded : Bool = false
    //var timesReviewed : Int = 0
    
    
    init(concept : String,
         newLearnings : String,
         oldSkills : String,
         percentNew : Int,
         timeLearned : Date,
         timeSpentLearning : Int,
         scheduledReviews : [Date],
         scheduledReviewDurations : [Int],
         reviews : [Date],
         reviewDurations : [Int],
         uploaded : Bool){
        
        self.concept = concept
        self.newLearnings = newLearnings
        self.oldSkills = oldSkills
        self.percentNew = percentNew
        self.timeLearned = timeLearned
        self.timeSpentLearning = timeSpentLearning
        self.scheduledReviews = scheduledReviews
        self.scheduledReviewDurations = scheduledReviewDurations
        self.reviews = reviews
        self.reviewDurations = reviewDurations
        self.uploaded = uploaded
    }
    
    init(timeLearned : Date){
        self.timeLearned = timeLearned
    }
}
