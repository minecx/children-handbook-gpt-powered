//
//  HomeView.swift
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


struct HomeView: View {
    @State private var buttonStates = Array(repeating: false, count: bookCategories.count)
    
    var body: some View {
        VStack {
            HStack {
                Text("Hello, User!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
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
                            bookCategory(index: index)
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
                    Text("12")
                }
            }
            .padding(.horizontal)
        }
    }
    
    func seeAllBooks() {
        print("see all book button")
    }
    
    func bookCategory(index: Int) {
        print("book category: \(bookCategories[index])")
        if (!buttonStates[index]) { // we were not selected
            buttonStates = Array(repeating: false, count: buttonStates.count)
            buttonStates[index] = true
        } else { // we were
            buttonStates[index] = false
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
