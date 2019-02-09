//
//  SkillObj.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-02.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import Foundation

class SkillObj{
    var concept : String = ""
    var newLearnings : String = ""
    var oldSkills : String = ""
    var percentNew : Int = 0
    var timeLearned : Date
    var timeSpentLearning : Int = 0
    var hasReview = false
    
    
    init(concept : String, newLearnings : String, oldSkills : String, percentNew : Int, timeLearned : Date, timeSpentLearning : Int, hasReview : Bool){
        self.concept = concept
        self.newLearnings = newLearnings
        self.oldSkills = oldSkills
        self.percentNew = percentNew
        self.timeLearned = timeLearned
        self.timeSpentLearning = timeSpentLearning
        self.hasReview = hasReview
    }
    
    init(timeLearned : Date){
        self.timeLearned = timeLearned
    }
}
