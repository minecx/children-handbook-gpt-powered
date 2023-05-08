//
//  DetailedBookView.swift
//  handbook-iOS
//
//  Created by Ann Zhou on 5/4/23.
//

import SwiftUI

struct DetailedBookView: View {
    let bookname: String
    let story: String
    
    var body: some View {
        VStack {
            Text(bookname)
                .font(Font.title.weight(.bold))
            ScrollView(.vertical) {
                Text(story)
            }
            Spacer()
        }
        .padding(.bottom, 50)
        .padding(.horizontal)
    }
}
