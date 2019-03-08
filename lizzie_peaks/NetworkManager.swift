//
//  networkManager.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-21.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import Foundation
import Alamofire
class NetworkManager{
    let SERVERIP = "http://10.8.0.1:9000"
    let SENDTOSERVER = true
    
    init(){
        NSLog("willSendToServer: \(SENDTOSERVER)")
    }
    
    func convertDate(date : Date) -> String{
        return String(Double(round(1000*date.timeIntervalSince1970)/1000))
    }
    
    func uploadSkill(skill : SkillObj){
        if(!SENDTOSERVER){
            NSLog("network turned off")
            return
        }
        NSLog("sending skill to server")
        
        let parameters: Parameters = [
            "concept" : skill.concept,
            "newLearnings" : skill.newLearnings,
            "oldSkills" : skill.oldSkills,
            "percentNew" : String(skill.percentNew),
            "timeLearned" : convertDate(date: skill.timeLearned),
            "timeSpentLearning" : String(skill.timeSpentLearning)
        ]
        
        //TODO: change the ip to the ip of the server
        AF.request(SERVERIP + "/upload_skill",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding()
            ).responseJSON { response in
                
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
        }
    }
    
    func uploadScheduledReview(concept: String, timeLearned: Date, reviewDate: Date, reviewDuration: Int){
        if(!SENDTOSERVER){
            NSLog("network turned off")
            return
        }
        NSLog("sending scheduledReview to server")
        
        let parameters: Parameters = [
            "concept" : concept,
            "timeLearned" : convertDate(date: timeLearned),
            "scheduledDate" : convertDate(date: reviewDate),
            "scheduledDuration" : String(reviewDuration)
        ]
        
        //TODO: change the ip to the ip of the server
        AF.request(SERVERIP + "/upload_scheduled_review",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding()
            ).responseJSON { response in
                
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
        }
    }

    func uploadReview(review : ReviewObj){
        if(!SENDTOSERVER){
            NSLog("network turned off")
            return
        }
        NSLog("sending review to server")
        
        let parameters: Parameters = [
            "concept" : review.concept,
            "dateReviewed" : convertDate(date: review.dateReviewed),
            "newLearnings" : review.newLearnings,
            "reviewDuration" : String(review.reviewDuration),
            "timeLearned" : convertDate(date: review.timeLearned)
        ]
        
        //TODO: change the ip to the ip of the server
        AF.request(SERVERIP + "/upload_review",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding()
            ).responseJSON { response in
                
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
        }
    }
}
