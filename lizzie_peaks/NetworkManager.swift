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
    let SERVERIP = "http://10.8.0.2:9000"
    func uploadSkill(skill : SkillObj){
        let parameters: Parameters = [
            "concept" : skill.concept,
            "newLearnings" : skill.newLearnings,
            "oldSkills" : skill.oldSkills,
            "percentNew" : skill.percentNew,
            "timeLearned" : skill.timeLearned,
            "timeSpentLearning" : skill.timeSpentLearning,
            "scheduledReviews" : skill.scheduledReviews,
            "scheduledReviewDurations" : skill.scheduledReviewDurations,
            "reviews" : skill.reviews,
            "reviewDurations" : skill.reviewDurations
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

    func uploadReview(review : ReviewObj){
        let parameters: Parameters = [
            "concept" : review.concept,
            "dateReviewed" : review.dateReviewed,
            "newLearnings" : review.newLearnings,
            "reviewDuration" : review.reviewDuration,
            "timeLearned" : review.timeLearned
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
