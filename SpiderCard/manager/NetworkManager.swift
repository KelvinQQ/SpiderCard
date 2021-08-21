//
//  NetworkManager.swift
//  SpiderCard
//
//  Created by admin on 2021/8/18.
//

import Cocoa
import Alamofire
import SwiftyJSON

struct NetworkError: Error {
    let code: Int
    let message: String
}
typealias NetworkCallbackSuccess = (_ result :JSON) -> Void
typealias NetworkCallbackFailure = (_ error: NetworkError) -> Void


class NetworkManager {
    private static var singleton: NetworkManager?
    
    static func instance() -> NetworkManager {
        if singleton == nil {
            singleton = NetworkManager()
        }
        return singleton!
    }
    
    private init() {
        
    }
    
    public func checkUpdate(success: @escaping NetworkCallbackSuccess, failure: @escaping NetworkCallbackFailure) {
        let uuid = UUID.init().uuidString.replacingOccurrences(of: "-", with: "")
        let timestamp = "\((Int)(Date.init().timeIntervalSince1970))"
        let url = "/1/classes/Version/UY42SSST"
        let toke = "wdu48f"
        let sign = (url + timestamp + toke + uuid).md5
        let headers: HTTPHeaders = ["content-type": "application/json",
                                    "X-Bmob-SDK-Type": "API",
                                    "X-Bmob-Safe-Sign": sign,
                                    "X-Bmob-Safe-Timestamp": timestamp,
                                    "X-Bmob-Noncestr-Key": uuid,
                                    "X-Bmob-Secret-Key": "7b9b4a69dd6439a9" ]
        Alamofire.request("https://api2.bmob.cn" + url,
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: headers
        )
        .validate()
        .responseJSON(completionHandler: { (response) in
            switch response.result.isSuccess {
            case true:
                guard let value = response.result.value else {
                    failure(NetworkError.init(code: -10001, message: "请求失败"))
                    return
                }
                let json = JSON(value)
                success(json)
            case false:
                failure(NetworkError.init(code: -10001, message: "请求失败"))
            }
        })
    }
}
