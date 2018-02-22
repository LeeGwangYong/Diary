//
//  CapsuleService.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 22..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

struct CapsuleService: APIService {
    static func getListData(url: String, parameter: [String : Any]?, completion: @escaping (Result<CapsuleResponse>)->()) {
        let url = self.getURL(path: url)
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .responseObject(completionHandler: { (response: DataResponse<CapsuleResponse>) in
            guard let resultData = getResult_StatusCode(response: response) else {return}
            completion(resultData)
        })
    }
}
