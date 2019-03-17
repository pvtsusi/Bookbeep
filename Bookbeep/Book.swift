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
    var language: String?
    var recommended: Bool
    
    //MARK: Initialization
    init?(isbn: String, title: String? = nil, author: String? = nil, language: String? = nil, recommended: Bool = false) {
        if isbn.isEmpty {
            return nil
        }
        if isbn.range(of: "^[0-9]+$", options: .regularExpression, range: nil, locale: nil) == nil {
            return nil
        }
        
        self.isbn = isbn
        self.title = title
        self.author = author
        self.language = language
        self.recommended = recommended
    }
    
    func toParams(overrideRecommended: Optional<Bool>? = Optional.none) -> Parameters {
        var parameters: Parameters = [
            "isbn": self.isbn
        ]
        if let recommended = overrideRecommended {
            parameters["recommended"] = recommended
        } else {
            parameters["recommended"] = self.recommended
        }
        if let title = self.title {
            parameters["title"] = title
        }
        if let author = self.author {
            parameters["author"] = author
        }
        if let language = self.language {
            parameters["language"] = language
        }
        return parameters
    }
}
