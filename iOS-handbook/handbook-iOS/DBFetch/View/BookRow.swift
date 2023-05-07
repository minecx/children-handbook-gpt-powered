//
//  BookRow.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 5/5/23.
//

import SwiftUI

struct BookRow: View {
    let book: Book
    let imageSize: CGFloat = 100
    
    var body: some View {
        HStack {
            if let url = URL(string: book.bookCoverURL) {
                AsyncImage(url: url) {
                    Color.gray
                }
                .scaledToFill()
                .frame(width: imageSize, height: imageSize)
                .clipped()
            } else {
                Color.gray.frame(width: imageSize, height: imageSize)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(book.bookname)
                    .font(.headline)
            }
        }
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        BookRow(book: Book.example1())
            .previewLayout(.fixed(width: 400, height: 200))
    }
}
