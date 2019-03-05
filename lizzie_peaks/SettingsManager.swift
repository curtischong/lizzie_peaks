//
//  SettingsManager.swift
//  
//
//  Created by Curtis Chong on 2019-02-02.
//
//TODO: Have multiple levels of verbose logging.
// 0 = everything
// 1 = minor user events
// 2 = major user events
// 3 = large - rare events
// 4 = large - one-time events

import UIKit

class SettingsManager{
    var defaults : UserDefaults!
    var defaultReview : String
    var verboseLogs = false
    let defaultColor = UIColor(red:0.96, green:0.77, blue:0.48, alpha:1.0)
    init(){
        defaultReview = "Simple"
        defaults = UserDefaults.standard
        self.getSavedSettings()
    }
    
    func getSavedSettings(){
        var shouldSaveDefault = false
        if let defaultReview = defaults.string(forKey: "defaultReview") {
            self.defaultReview = defaultReview
        }else{
            print("Couldn't retrieve defaultReview from storage. Setting default settings")
            shouldSaveDefault = true
        }
        if(shouldSaveDefault){
            saveSettings()
        }
    }
    
    func saveSettings(){
        defaults.set(defaultReview, forKey: "defaultReview")
    }
}
