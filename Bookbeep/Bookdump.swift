//
//  Bookdump.swift
//  Bookbeep
//
//  Created by Petteri Susi on 21/08/2019.
//  Copyright © 2019 Petteri Susi. All rights reserved.
//

import Foundation
import Alamofire

class Bookdump {
    
    static let shared: Bookdump = Bookdump()
    
    let sessionManager: SessionManager = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 5
        sessionConfiguration.timeoutIntervalForResource = 5
        return Alamofire.SessionManager(configuration: sessionConfiguration)
    }()
    
    private init() { }
    
    static func configured(url: String? = nil, user: String? = nil, pass: String? = nil) -> Bool {
        guard let urlVal = url != nil ? url : UserDefaults.standard.string(forKey: "BookdumpUrl") else {
            return false
        }
        let parsedUrl = URLComponents(string: urlVal)
        if (parsedUrl == nil || parsedUrl!.string == nil) {
            return false
        }
        let userVal = user != nil ? user : UserDefaults.standard.string(forKey: "BookdumpUser");
        if (userVal == nil || userVal!.isEmpty) {
            return false
        }
        let passVal = pass != nil ? pass : UserDefaults.standard.string(forKey: "BookdumpPass");
        if (passVal == nil || passVal!.isEmpty) {
            return false
        }
        return true
    }
    
    static func normalizeApiBaseUrl() -> String {
        guard let url = UserDefaults.standard.string(forKey: "BookdumpUrl") else {
            fatalError("Bookdump URL not set")
        }
        guard var urlComponents = URLComponents(string: url) else {
            fatalError("Invalid URL")
        }
        if (urlComponents.scheme != "https") {
            urlComponents.scheme = "https"
        }
        if (urlComponents.path.hasSuffix("/")) {
            urlComponents.path = String(urlComponents.path.dropLast())
        }
        if (!urlComponents.path.hasSuffix("/api")) {
            urlComponents.path = "\(urlComponents.path)/api"
        }
        if (urlComponents.host == nil && urlComponents.path.contains("/")) {
            let hostAndPath = urlComponents.path.split(separator: "/", maxSplits: 1, omittingEmptySubsequences: true)
            urlComponents.host = String(hostAndPath[0])
            urlComponents.path = "/\(hostAndPath[1])"
        }
        return urlComponents.string!
    }
    
    static func apiBaseUrl() -> String {
        guard let url = UserDefaults.standard.string(forKey: "BookdumpUrl") else {
            return ""
        }
        return url
    }
    
    static func apiUser() -> String {
        guard let user = UserDefaults.standard.string(forKey: "BookdumpUser") else {
            fatalError("Bookdump username not set")
        }
        return user
    }

    static func apiPass() -> String {
        guard let pass = UserDefaults.standard.string(forKey: "BookdumpPass") else {
            fatalError("Bookdump password not set")
        }
        return pass
    }
    
    func testConnection() {
        
        postStatus(loading: true)
        
        let url = "\(Bookdump.normalizeApiBaseUrl())/test"
        
        sessionManager.request(url)
            .authenticate(user: Bookdump.apiUser(), password: Bookdump.apiPass())
            .responseJSON { response in
                if (response.response == nil) {
                    self.postStatus(loading: false, message: "No response from server")
                } else if (response.error != nil) {
                    if (response.response!.statusCode == 401) {
                        self.postStatus(loading: false, message: "Bad username or password")
                    } else {
                        self.postStatus(loading: false, message: "Connection failed")
                    }
                } else if (response.response!.statusCode != 200) {
                    self.postStatus(loading: false, message: "Server responded with an error")
                } else {
                    self.postStatus(loading: false, message: "Connection OK!")
                }
        }
    }

    private func postStatus(loading: Bool, message: String? = nil) {
        var userInfo: [AnyHashable: Any] = ["Loading": loading]
        if (message != nil) {
            userInfo["Message"] = message
        }
        NotificationCenter.default.post(name: Notification.Name("TestConnectionStatus"), object: nil, userInfo: userInfo)
    }
}
