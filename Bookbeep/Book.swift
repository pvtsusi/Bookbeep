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
    var mock: Bool
    
    //MARK: Initialization
    init?(isbn: String, title: String? = nil, author: String? = nil, language: String? = nil, recommended: Bool = false, mock: Bool = false) {
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
        self.mock = mock
    }
    
    static func mockBook() -> Book {
        let isbnWithoutChecksum = (0..<12).map{_ in Int(arc4random_uniform(10))}
        var sum = 0
        for i in 0..<isbnWithoutChecksum.count {
            sum += isbnWithoutChecksum[i] * (i % 2 == 0 ? 1 : 3)
        }
        let checksum = 10 - sum % 10;
        var isbn = ""
        for digit in isbnWithoutChecksum {
            isbn += String.init(digit)
        }
        isbn += String.init(checksum)        
        return Book.init(isbn: isbn, title: "Title", author: "Author", mock: true)!
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
        if self.mock {
            parameters["mock"] = true
        }
        return parameters
    }
}
