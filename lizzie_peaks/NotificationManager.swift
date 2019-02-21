//
//  NotificationManager.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-02.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import UserNotifications
import Foundation

class NotificationManager{
    let appContextFormatter = DateFormatter()
    let center = UNUserNotificationCenter.current()
     //let triggerOneMin = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
    init(){
        appContextFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    func generateIdentifiers(timeLearned : Date, reviewDates : [Date]) -> [String]{
        var allIdentifiers : [String] = []
        for curDate in reviewDates{
            allIdentifiers.append(appContextFormatter.string(from: timeLearned) + appContextFormatter.string(from: curDate))
        }
        return allIdentifiers
    }
    
    func setNotification(title: String, body : String, reviewDate : Date, timeLearned : Date){
        
        var triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: reviewDate)
        triggerDate.hour = 8
        let reviewDateTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        // note: this means that you cannot review the same thing twice in one day
        let identifier = appContextFormatter.string(from: timeLearned) + appContextFormatter.string(from: reviewDate)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: reviewDateTrigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("couldn't create notification with error: \(error)")
                return
            }
        })
        
        print("notification set for Date: \(reviewDate)")
    }
    
    func removeNotifications(timeLearned : Date, reviewDates : [Date]){
        let allIdentifiers = generateIdentifiers(timeLearned : timeLearned, reviewDates : reviewDates)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: allIdentifiers)
    }
}
