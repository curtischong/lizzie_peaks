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
    
    func scheduleReview(skill : SkillObj){
        /*let curReview = ReviewObj(concept : skill.concept,
                                  dateReviewed : "",
                                  newLearnings : skill.newLearnings,
                                  reviewDuration : skill.timeSpentLearning)*/
        self.scheduleNewReview(skill : skill)
    }
    
    //TODO: consider refactoring this section into calculateSinpleReview(), calculateMLReview etc.
    //TODO: instead of adding a constant time, batch these notifications to the morning
    func scheduleNewReview(skill : SkillObj){
        let timesReviewed = skill.reviews.count
        var scheduledReview = Date()
        var scheduledReviewDuration = -1
        if(settingsManager.defaultReview == "Simple"){
            if(settingsManager.briefReviews){
                scheduledReview = skill.timeLearned.addingTimeInterval(TimeInterval(60.0))
                scheduledReviewDuration = 120
            }else if(timesReviewed == 0){
                scheduledReview = skill.timeLearned.addingTimeInterval(TimeInterval(60.0 * 60.0 * 24.0))
                scheduledReviewDuration = 60 * 10
            }else if(timesReviewed == 1){
                scheduledReview = skill.timeLearned.addingTimeInterval(TimeInterval(60.0 * 60.0 * 24.0 * 7.0))
                scheduledReviewDuration = 60 * 5
            }else if(timesReviewed == 2){
                scheduledReview = skill.timeLearned.addingTimeInterval(TimeInterval(60.0 * 60.0 * 24.0 * 30.0))
                scheduledReviewDuration = 60 * 3
            }else{
                scheduledReview = skill.timeLearned.addingTimeInterval(TimeInterval(60.0 * 60.0 * 24.0 * 30.0 * 9999))
                scheduledReviewDuration = 60 * 3 * 9999
            }
            
            skill.scheduledReviews.append(scheduledReview)
            skill.scheduledReviewDurations.append(scheduledReviewDuration)
            
            dataManager.updateSkill(skill: skill)
            
            let reviewTitle = "Get reviewing on \(skill.concept) Curtis!"
            let reviewBody = "Spend only \(scheduledReviewDuration/60) minutes to bring you back to 100%"
            notificationManager.setNotification(title : reviewTitle, body : reviewBody, reviewDate : scheduledReview)
            //dataManager.insertReview(review : review)
        }
    }
}

