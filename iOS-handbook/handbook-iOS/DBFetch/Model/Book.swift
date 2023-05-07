//
//  Book.swift
//  handbook-iOS
//
//  Created by Bob on 5/5/23.
//

//{
//"id": 1,
//"bookname": "sample_book1",
//"author": "John Doe",
//"description": "The Book for The Book Day",
//"story": "On the book day, children dress up as their favourite characters from books and bring them to school. They also bring their favourite books to school and read them with their classmates and teachers.",
//"genre": "cartoon",
//"book_url": "url_placeholder",
//"book_cover": "cover_placeholder"
//}

import Foundation

struct Book: Codable, CustomStringConvertible, Identifiable {
    let id: Int
    let bookname: String
    let author: String
    let description: String
    let genre: String
    let story: String
    let bookURL: String
    let bookCoverURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case bookname
        case author
        case description
        case genre
        case story
        case bookURL = "book_url"
        case bookCoverURL = "book_cover"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        bookname = try values.decode(String.self, forKey: .bookname)
        author = try values.decode(String.self, forKey: .author)
        description = try values.decode(String.self, forKey: .description)
        genre = try values.decode(String.self, forKey: .genre)
        story = try values.decode(String.self, forKey: .story)
        bookURL = try values.decode(String.self, forKey: .bookURL)
        bookCoverURL = try values.decode(String.self, forKey: .bookCoverURL)
    }
    
    init(bookname: String, id:Int, author:String, description:String, genre: String, bookURL:String, story: String, bookCoverURL: String) {
        self.bookname = bookname
        self.id = id
        self.author = author
        self.description = description
        self.genre = genre
        self.story = story
        self.bookCoverURL = bookCoverURL
        self.bookURL = bookURL
    }
    
    static func example1() -> Book {
        
        return Book(bookname: "Book sample 1", id: 234, author: "John Doe", description: "This is book sample 1", genre: "Bedtime", bookURL: "123", story: "Once upon a time....", bookCoverURL: "https://picsum.photos/id/237/200/300")
    }

    static func example2() -> Book {

        return Book(bookname: "Book sample 2", id: 324, author: "Cecilia Chen", description: "This is book sample 2", genre: "Adventure", bookURL: "123", story: "There was a child...", bookCoverURL: "https://unsplash.com/photos/rNqs9hM0U8I")
    }
}

