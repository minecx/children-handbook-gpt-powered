//
//  BookModel.swift
//  handbook-iOS
//
//  Created by Ann Zhou on 5/6/23.
//

import Foundation

struct Handbook: Codable, Hashable {
    var id: Int
    var bookname: String
    var author: String
    var description: String
    var story: String
    var genre: String
    var book_url: String
    var book_cover: String
}
