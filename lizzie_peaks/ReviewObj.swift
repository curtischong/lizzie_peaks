//
//  ReviewObj.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-02.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import Foundation

class ReviewObj{
    var concept : String
    var lastTimeReviewed : Date
    var newLearnings : String
    var timesReviewed : Int
    var reviewDuration : Int
    var timeLearned : Date
    
    init(concept : String, lastTimeReviewed : Date, timesReviewed : Int, newLearnings : String, reviewDuration : Int, timeLearned : Date){
        self.concept = concept
        self.lastTimeReviewed = lastTimeReviewed
        self.newLearnings = newLearnings
        self.timesReviewed = timesReviewed
        self.reviewDuration = reviewDuration
        self.timeLearned = timeLearned
    }
}
