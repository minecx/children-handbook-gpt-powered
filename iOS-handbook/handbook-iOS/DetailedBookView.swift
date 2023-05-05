//
//  DetailedBookView.swift
//  handbook-iOS
//
//  Created by Ann Zhou on 5/4/23.
//

import SwiftUI

struct DetailedBookView: View {
    let book: String
    
    var body: some View {
        VStack {
            Image(book)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
            Text(book)
        }
    }
}
