//
//  Bookdump.swift
//  Bookbeep
//
//  Created by Petteri Susi on 21/08/2019.
//  Copyright © 2019 Petteri Susi. All rights reserved.
//

import Foundation

class Bookdump {
    static func configured() -> Bool {
        guard let url = UserDefaults.standard.string(forKey: "bookdump_url") else {
            return false
        }
        let parsedUrl = URLComponents(string: url)
        return parsedUrl != nil && parsedUrl?.string != nil
    }
    
    static func apiBaseUrl() -> String {
        guard let url = UserDefaults.standard.string(forKey: "bookdump_url") else {
            fatalError("Bookdump URL not set")
        }
        guard var urlComponents = URLComponents(string: url) else {
            fatalError("Invalid URL")
        }
        var modified = false
        if (urlComponents.scheme != "https") {
            urlComponents.scheme = "https"
            modified = true
        }
        if (!urlComponents.path.hasSuffix("/api")) {
            urlComponents.path = "\(urlComponents.path)/api"
            modified = true
        }
        let validUrl = urlComponents.string!
        if (modified) {
            UserDefaults.standard.set(validUrl, forKey: "bookdump_url")
        }
        return validUrl
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
