//
//  ReviewObj.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-02.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

//TODO: change the constructor for this
import Foundation

class ReviewObj{
    var concept : String = ""
    var timeReviewed : Date = Date.from(year: 1970, month: 1, day: 1)!
    var newLearnings : String = ""
    var reviewDuration : Int = 0
    var timeLearned : Date = Date.from(year: 1970, month: 1, day: 1)!
    var uploaded : Bool = false
    
    init(concept : String,
         timeReviewed : Date,
         newLearnings : String,
         reviewDuration : Int,
         timeLearned : Date,
         uploaded : Bool){
        
        self.concept = concept
        self.timeReviewed = timeReviewed
        self.newLearnings = newLearnings
        self.reviewDuration = reviewDuration
        self.timeLearned = timeLearned
        self.uploaded = uploaded
    }
    
    init(concept : String,
        timeReviewed : Date,
        reviewDuration : Int,
        timeLearned : Date){
        self.concept = concept
        self.timeReviewed = timeReviewed
        self.reviewDuration = reviewDuration
        self.timeLearned = timeLearned
    }
}
