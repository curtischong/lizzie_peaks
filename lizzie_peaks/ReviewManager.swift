//
//  ReviewManager.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-02.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

// Note, the default value of the scheduled review time is the timeReviewed
// This value is changed when scheduleNewReview is called
import Foundation

class ReviewManager{
    let notificationManager = NotificationManager()
    let dataManager = DataManager()
    let settingsManager = SettingsManager()
    init(){
        
    }
    
    func createReview(skill : SkillObj){

        let curReview = ReviewObj(concept : skill.concept,
                                  lastTimeReviewed : skill.timeLearned,
                                  timesReviewed : 0,
                                  newLearnings : skill.newLearnings,
                                  reviewDuration : skill.timeSpentLearning,
                                  scheduledDate : skill.timeLearned,
                                  scheduledDuration: -1,
                                  timeLearned : skill.timeLearned)
        self.scheduleNewReview(review : curReview)
    }
    
    //TODO: consider refactoring this section into calculateSinpleReview(), calculateMLReview etc.
    func scheduleNewReview(review : ReviewObj){
        if(settingsManager.defaultReview == "Simple"){
            if(settingsManager.briefReviews){
                review.scheduledDate = review.timeLearned.addingTimeInterval(TimeInterval(30.0))
                review.scheduledDuration = 60
            }else if(review.timesReviewed == 0){
                review.scheduledDate = review.timeLearned.addingTimeInterval(TimeInterval(60.0 * 60.0 * 24.0))
                review.scheduledDuration = 60 * 10
            }else if(review.timesReviewed == 1){
                review.scheduledDate = review.timeLearned.addingTimeInterval(TimeInterval(60.0 * 60.0 * 24.0 * 7.0))
                review.scheduledDuration = 60 * 5
            }else if(review.timesReviewed == 2){
                review.scheduledDate = review.timeLearned.addingTimeInterval(TimeInterval(60.0 * 60.0 * 24.0 * 30.0))
                review.scheduledDuration = 60 * 3
            }
            let reviewTitle = "Get reviewing on \(review.concept) Curtis!"
            let reviewBody = "Spend only \(review.scheduledDuration/60) minutes to bring you back to 100%"
            notificationManager.setNotification(title : reviewTitle, body : reviewBody, reviewDate : review.scheduledDate)
            dataManager.insertReview(review : review)
        }
    }
}

