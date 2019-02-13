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
    var concept : String
    var dateReviewed : Date
    var newLearnings : String
    var reviewDuration : Int
    
    init(concept : String,
         dateReviewed : Date,
         newLearnings : String,
         reviewDuration : Int){
        
        self.concept = concept
        self.dateReviewed = dateReviewed
        self.newLearnings = newLearnings
        self.reviewDuration = reviewDuration
    }
}
