//
//  SettingsManager.swift
//  
//
//  Created by Curtis Chong on 2019-02-02.
//

import Foundation

class SettingsManager{
    var defaults : UserDefaults!
    var defaultReview : String
    var briefReviews: Bool
    var verboseLogs = false
    init(){
        defaultReview = "Simple"
        defaults = UserDefaults.standard
        briefReviews = false
        self.getSavedSettings()
    }
    
    func getSavedSettings(){
        if let defaultReview = defaults.string(forKey: "defaultReview") {
            self.defaultReview = defaultReview
        }else{
            print("Couldn't retrieve defaultReview from storage.")
        }
        
        if let briefReviews = defaults.string(forKey: "briefReviews") {
            if(briefReviews == "true"){
                self.briefReviews = true
            }else{
                self.briefReviews = false
            }
        }else{
            print("Couldn't retrieve briefReviews from storage.")
        }
    }
    
    func saveSettings(){
        defaults.set(defaultReview, forKey: "defaultReview")
        if(briefReviews){
            defaults.set("true", forKey: "briefReviews")
        }else{
            defaults.set("false", forKey: "briefReviews")
        }
    }
}
