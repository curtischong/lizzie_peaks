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

class ReviewScheduleManager{
    let notificationManager = NotificationManager()
    let dataManager = DataManager()
    let settingsManager = SettingsManager()
    init(){
        
    }
    
    //TODO: consider refactoring this section into calculateSinpleReview(), calculateMLReview etc.
    
    
    func nextMorning(date : Date) -> Date{
        let hourOfDate = Calendar.current.component(.hour, from: date)
        let correctedDay : Date
        if(hourOfDate < 5){ // if I learned this past 7pm, review the content the in 2 days, not the next morning
            //correctedDay = date.addingTimeInterval(TimeInterval(60.0 * 60.0 * 24.0))
            correctedDay = date
        }else{
            correctedDay = date.addingTimeInterval(TimeInterval(60.0 * 60.0 * 24.0))
        }
        
        // set to nearest morning
        let newDate = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: correctedDay)
        if(newDate == nil){
            NSLog("Date coudn't be created. blame daylight saving / leap seconds idk")
        }
        
        // round to nearest hour
        var components = NSCalendar.current.dateComponents([.minute], from: newDate!)
        let minute = components.minute ?? 0
        components.minute = minute >= 30 ? 60 - minute : -minute
        
        let hourAdjusted = Calendar.current.date(byAdding: components, to: newDate!)!
        return hourAdjusted
    }
    
    func scheduleReview(skill : SkillObj){
        let timesReviewed = skill.reviews.count
        var scheduledReview = Date()
        var scheduledReviewDuration = -1
        if(settingsManager.defaultReview == "Simple"){
            if(timesReviewed == 0){
                scheduledReview = skill.timeLearned.addingTimeInterval(TimeInterval(0.0))
                scheduledReviewDuration = 60 * 10
            }else if(timesReviewed == 1){
                scheduledReview = skill.timeLearned.addingTimeInterval(TimeInterval(60.0 * 60.0 * 24.0 * 5.0))
                scheduledReviewDuration = 60 * 5
            }else if(timesReviewed == 2){
                scheduledReview = skill.timeLearned.addingTimeInterval(TimeInterval(60.0 * 60.0 * 24.0 * 28.0))
                scheduledReviewDuration = 60 * 3
            }else{
                scheduledReview = skill.timeLearned.addingTimeInterval(TimeInterval(60.0 * 60.0 * 24.0 * 29.0 * 9999))
                scheduledReviewDuration = 60 * 3 * 9999
            }
        }else if(settingsManager.defaultReview == "Brief"){
            scheduledReview = skill.timeLearned.addingTimeInterval(TimeInterval(60.0))
            scheduledReviewDuration = 120
        }

        let scheduledMorning = self.nextMorning(date : scheduledReview)
        
        skill.scheduledReviews.append(scheduledMorning)
        skill.scheduledReviewDurations.append(scheduledReviewDuration)
        
        dataManager.updateSkill(skill: skill)
        
        let reviewTitle = "Get reviewing on \(skill.concept) Curtis!"
        let reviewBody = "Spend only \(scheduledReviewDuration/60) minutes to bring you back to 100%"
        notificationManager.setNotification(title : reviewTitle, body : reviewBody, reviewDate : scheduledMorning, timeLearned : skill.timeLearned)
        //dataManager.insertReview(review : review)
    }
}

