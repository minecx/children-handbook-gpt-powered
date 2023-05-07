//
//  BookListView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 5/5/23.
//

import SwiftUI

struct BookListView: View {
    let books: [Book]
    
    var body: some View {
        List {
            ForEach(books) { book in
                Text(book.bookname)
            }
        }
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView(books: BookFetcher.successState().books)
    }
}
