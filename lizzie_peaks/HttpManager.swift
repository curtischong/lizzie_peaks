//
//  HttpManager.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-02.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import Foundation
import Alamofire
class HttpManager{
    
    let SERVER_IP = "http://10.8.0.1:9000/"
    init(){
    }
    func uploadSkills(){
        /*
        let parameters: Parameters = [
            "dataPointNames": json(from : dataPointNames) as Any,
            "startTimes": json(from : startTimes) as Any,
            "endTimes": json(from : endTimes) as Any,
            "measurements": json(from : measurements) as Any,
        ]
        
        AF.request(SERVER_IP + "upload_learned_skills",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding()
            ).responseJSON { response in
                NSLog("Skills Sent!")
        }*/
    }
}
