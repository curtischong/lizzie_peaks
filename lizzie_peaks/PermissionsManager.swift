//
//  PermissionsManager.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-02.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import Foundation
import UserNotifications

class PermissionsManager{
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound];
    init(){
        
    }
    func requestNotifications(){
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Couldn't gain authorization to the notification center.")
            }else{
                 print("Authorization to the notification center granted!")
            }
        }
    }
    func requestPermissions(){
        requestNotifications()
    }
}
