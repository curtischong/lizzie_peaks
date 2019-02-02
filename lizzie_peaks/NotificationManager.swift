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
    let center = UNUserNotificationCenter.current()
     //let triggerOneMin = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
    init(){
        
    }
    
    func setNotification(title: String, body : String, reviewDate : Date){
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: reviewDate)
        let reviewDateTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let identifier = "firstnotification"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: reviewDateTrigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("couldn't create notification with error: \(error)")
                return
            }
        })
        print("notification set!")
    }
}
