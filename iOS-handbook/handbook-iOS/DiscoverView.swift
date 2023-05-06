//
//  DiscoverView.swift
//  handbook-iOS
//
//  Created by Bob on 4/24/23.
//

import SwiftUI

let backendURL = "http://35.236.214.238/api"

let ourGray = Color(red: 153/255, green: 153/255, blue: 153/255)
let genericPadding: CGFloat = 20
let bookCategories = [
    "Bedtime",
    "Classic Tales",
    "Animals & Nature",
    "Emotional Intelligence",
    "Science & Tech",
    "ABC & Alphabet",
    "Diversity & Inclusion",
    "Travel & Adventure"
]
let books = [
    "sample_book1",
    "sample_book2",
    "sample_book3",
]
let musics = [
    "sample_music1",
    "sample_music2",
    "sample_music3",
]

struct DiscoverView: View {
    
    @State private var fetchedBooks: [Book] = []
    @State private var buttonStates = Array(repeating: false, count: bookCategories.count)
    @EnvironmentObject var userData: User
    
    var body: some View {
        NavigationView {
            
            ScrollView(.vertical) {

                HStack {
                    Text("Hello, \n\(userData.firstName)!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Image("sample_avatar")
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Books For You")
                        .font(.title)
                    
                    Spacer()
                    
                    Button(action: {
                        seeAllBooks()
                    }) {
                        Text("See All")
                            .foregroundColor(ourGray)
                    }
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal) {
                    HStack(spacing: genericPadding) {
                        ForEach(0..<buttonStates.count) { index in
                            Button(action: {
                                switchCategory(index: index)
                            }) {
                                Text(bookCategories[index])
                                    .foregroundColor(buttonStates[index] ? Color.blue : ourGray)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // fetch book from BE & render
                ScrollView(.horizontal) {
                    HStack(spacing: genericPadding) {
                        ForEach(fetchedBooks, id: \.self) { book in
                            VStack {
                                Image(book.bookname)
                                Text(book.bookname)
                            }
                        }
                    }
                    .onAppear {
                        getAllBooks()
                    }
                }
                .padding(.horizontal)
                
                Text("Continue Reading")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    // padding left
                    .padding(.leading)
                
                // TODO: hide if none found in history
                ScrollView(.horizontal) {
                    HStack(spacing: genericPadding) {
                        ForEach(1..<3) { index in
                            NavigationLink(destination: DetailedBookView(book: books[index])) {
                                VStack {
                                    Image(books[index])
                                    Text(books[index]).foregroundColor(.black)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Music Ignites")
                        .font(.title)
                    
                    Spacer()
                    
                    Button(action: {
                        seeAllMusic()
                    }) {
                        Text("See All")
                            .foregroundColor(ourGray)
                    }
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal) {
                    HStack(spacing: genericPadding) {
                        ForEach(musics, id: \.self) { mus in
                            NavigationLink(destination: DetailedMusicView(music: mus)) {
                                VStack {
                                    Image(mus)
                                    Text(mus).foregroundColor(.black)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
            }
            .padding(.top)
            .padding(.bottom, 50)
        }
    }

    func getAllBooks() {
        let url = URL(string: "\(backendURL)/books")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                // network error
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                // Handle invalid HTTP response
                print("Invalid response")
                return
            }
            
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let bookArray = json["books"] as? [[String: Any]] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: bookArray, options: [])
                        let decodedResponse = try JSONDecoder().decode([Book].self, from: jsonData)
                        DispatchQueue.main.async {
                            self.fetchedBooks = decodedResponse
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
        }
        task.resume()
    }
    
    func seeAllBooks() {
        print("tapped see all book button")
    }
    
    func seeAllMusic() {
        print("tapped see all music button")
    }
    
    func switchCategory(index: Int) {
        print("book category: \(bookCategories[index])")
        buttonStates[index].toggle()
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
