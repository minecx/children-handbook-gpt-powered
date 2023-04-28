//
//  ChildrenBook.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/28/23.
//

import Foundation

struct ChildrenBook: Codable, CustomStringConvertible {
    let id: String
    let bookName: String
    let bookURL: String
    let coverURL: String
    let author: String
    let genre: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case bookName = "bookname"
        case author
        case description
        case genre
        case bookURL = "book_url"
        case coverURL = "book_cover"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        bookName = try values.decode(String.self, forKey: .bookName)
        bookURL = try values.decode(String.self, forKey: .bookURL)
        coverURL = try values.decode(String.self, forKey: .coverURL)
        author = try values.decode(String.self, forKey: .author)
        genre = try values.decode(String.self, forKey: .genre)
        description = try values.decode(String.self, forKey: .description)
    }
}

