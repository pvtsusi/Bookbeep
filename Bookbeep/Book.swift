//
//  Book.swift
//  Bookbeep
//
//  Created by Petteri Susi on 12/03/2019.
//  Copyright © 2019 Petteri Susi. All rights reserved.
//

import Foundation
import Alamofire

class Book {
    //MARK: Properties
    var isbn: String
    var title: String?
    var author: String?
    
    //MARK: Initialization
    init?(isbn: String, title: String? = nil, author: String? = nil) {
        if isbn.isEmpty {
            return nil
        }
        if isbn.range(of: "^[0-9]+$", options: .regularExpression, range: nil, locale: nil) == nil {
            return nil
        }
        
        self.isbn = isbn
        self.title = title
        self.author = author
    }
    
    func toParams() -> Parameters {
        var parameters: Parameters = [
            "isbn": self.isbn
        ]
        if let title = self.title {
            parameters["title"] = title
        }
        if let author = self.author {
            parameters["author"] = author
        }
        return parameters
    }
}
