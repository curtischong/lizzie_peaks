//
//  ReviewManager.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-02.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import Foundation

class ReviewManager{
    let notificationManager = NotificationManager()
    init(){
        
    }
    
    func createReview(concept : String, timeLearned : Date, timeSpentLearning : Int){
        let reviewDate = timeLearned.addingTimeInterval(TimeInterval(20.0))
        notificationManager.setNotification(title : concept, body : String(timeSpentLearning), reviewDate : reviewDate)
    }
}

