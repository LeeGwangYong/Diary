//
//  VerifyEmailService.swift
//  Diary
//
//  Created by 박수현 on 22/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import Foundation
import Alamofire

struct VerifyEmailService: APIService {
    static func getSignData(url: String, parameter: [String : Any]?, completion: @escaping (Result<Any>)->()) {
        let url = self.getURL(path: url)
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
            guard let resultData = getResult_StatusCode(response: response) else {return}
            completion(resultData)
        }
    }
}
