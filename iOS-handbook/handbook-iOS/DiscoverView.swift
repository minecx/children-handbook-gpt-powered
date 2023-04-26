//
//  DiscoverView.swift
//  handbook-iOS
//
//  Created by Bob on 4/24/23.
//

import SwiftUI

let ourGray = Color(red: 153/255, green: 153/255, blue: 153/255)
let geneticPadding: CGFloat = 20
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
    "sample_book1",
    "sample_book2",
    "sample_book3",
]
let musics = [
    "sample_music1",
    "sample_music2",
    "sample_music3",
    "sample_music1",
    "sample_music2",
    "sample_music3",
]
let username = "Userrrr"

struct DiscoverView: View {
    @State private var buttonStates = Array(repeating: false, count: bookCategories.count)
    
    var body: some View {
        ScrollView(.vertical) {
            HStack {
                Text("Hello, \n\(username)!")
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
                HStack(spacing: geneticPadding) {
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
            
            ScrollView(.horizontal) {
                HStack(spacing: geneticPadding) {
                    ForEach(0..<books.count) { index in
                        Button(action: {
                            print("hit")
                        }) {
                            Image(books[index])
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Text("Continue Reading")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                // padding left
                .padding(.leading)
            
            Text("TODO: should be hidden if none found")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            // TODO: hide if none found in history
            ScrollView(.horizontal) {
                HStack(spacing: geneticPadding) {
                    ForEach(1..<5) { index in
                        Button(action: {
                            print("hit")
                        }) {
                            Image(books[index])
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
                HStack(spacing: geneticPadding) {
                    ForEach(0..<musics.count) { index in
                        VStack {
                            Button(action: {
                                print("hit")
                            }) {
                                Image(musics[index])
                            }
                            
                            // TODO: change song name
                            Text("song")
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
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
