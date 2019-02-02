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
    init(){
        defaultReview = "Simple"
        defaults = UserDefaults.standard
    }
    
    func setSettings(sentDefaultReview : String){
        
    }
    
    func getSavedSettings(){
        if let dateLastSyncedWithServer = defaults.string(forKey: "defaultReview") {
            defaultReview = dateLastSyncedWithServer
        }else{
            print("Couldn't retrieve default review from storage.")
        }
    }
    
    func saveSettings(){
        defaults.set( defaultReview, forKey: "defaultReview")
    }
}
