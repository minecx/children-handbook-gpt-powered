//
//  DiscoverView.swift
//  handbook-iOS
//
//  Created by Bob on 4/24/23.
//

import SwiftUI

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
//let username = "Userrrr"
//let username = FirebaseAuth.share.userData.firstName
//print("User name: ", user.name ?? "unknown")
//print("User email: ", user.email ?? "unknown")

struct DiscoverView: View {
    
    @State private var buttonStates = Array(repeating: false, count: bookCategories.count)
    @EnvironmentObject var userData: User
    
    var body: some View {
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

            NavigationView {
                ScrollView(.horizontal) {
                    HStack(spacing: genericPadding) {
                        ForEach(0..<books.count) { index in
                            NavigationLink(destination: DetailedBookView(book: books[index])) {
                                Image(books[index])
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
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
                HStack(spacing: genericPadding) {
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
            
            NavigationView {
                ScrollView(.horizontal) {
                    HStack(spacing: genericPadding) {
                        ForEach(0..<musics.count) { index in
                            NavigationLink(destination: DetailedMusicView(music: musics[index])) {
                                VStack {
                                    Image(musics[index])
                                    Text(musics[index]).foregroundColor(.black)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
        .padding(.bottom, 50)
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
