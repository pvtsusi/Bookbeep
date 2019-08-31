//
//  Bookdump.swift
//  Bookbeep
//
//  Created by Petteri Susi on 21/08/2019.
//  Copyright © 2019 Petteri Susi. All rights reserved.
//

import Foundation

class Bookdump {
    static func configured(url: String? = nil, user: String? = nil, pass: String? = nil) -> Bool {
        guard let urlVal = url != nil ? url : UserDefaults.standard.string(forKey: "bookdump_url") else {
            return false
        }
        let parsedUrl = URLComponents(string: urlVal)
        if (parsedUrl == nil || parsedUrl!.string == nil) {
            return false
        }
        let userVal = user != nil ? user : UserDefaults.standard.string(forKey: "bookdump_user");
        if (userVal == nil || userVal!.isEmpty) {
            return false
        }
        let passVal = pass != nil ? pass : UserDefaults.standard.string(forKey: "bookdump_pass");
        if (passVal == nil || passVal!.isEmpty) {
            return false
        }
        return true
    }
    
    static func normalizeApiBaseUrl() -> String {
        guard let url = UserDefaults.standard.string(forKey: "bookdump_url") else {
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
        print(urlComponents.string!)
        return urlComponents.string!
    }
    
    static func apiBaseUrl() -> String {
        guard let url = UserDefaults.standard.string(forKey: "bookdump_url") else {
            return ""
        }
        return url
    }
    
    static func apiUser() -> String {
        guard let user = UserDefaults.standard.string(forKey: "bookdump_user") else {
            fatalError("Bookdump username not set")
        }
        return user
    }

    static func apiPass() -> String {
        guard let pass = UserDefaults.standard.string(forKey: "bookdump_pass") else {
            fatalError("Bookdump password not set")
        }
        return pass
    }
}
