//
//  Book.swift
//  handbook-iOS
//
//  Created by Bob on 5/5/23.
//

import Foundation

struct Book: Decodable, Hashable {
    var bookname: String
    var author: String
    var description: String
    var genre: String
    var story: String
    var book_url: String
    var book_cover: String
    var saved_by_users: String
    var continue_by_users: String

    init() {
        self.bookname = ""
        self.author = ""
        self.description = ""
        self.genre = ""
        self.story = ""
        self.book_url = ""
        self.book_cover = ""
        self.saved_by_users = ""
        self.continue_by_users = ""
    }

    init(bookname: String?, author: String?, description: String?, genre: String?, story: String?, book_url: String?, book_cover: String?, saved_by_users: String?, continue_by_users: String?) {
        self.bookname = bookname ?? ""
        self.author = author ?? ""
        self.description = description ?? ""
        self.genre = genre ?? ""
        self.story = story ?? ""
        self.book_url = book_url ?? ""
        self.book_cover = book_cover ?? ""
        self.saved_by_users = saved_by_users ?? ""
        self.continue_by_users = continue_by_users ?? ""
    }
}
