//
//  BookNetworkingView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 5/5/23.
//

import SwiftUI

struct BookNetworkingView: View {
    @StateObject var bookFetcher = BookFetcher()
    var body: some View {
        if bookFetcher.isLoading {
            LoadingView()
        } else if bookFetcher.errorMessage != nil {
            BookErrorView(bookFetcher: bookFetcher)
        } else {
            BookListView(books: bookFetcher.books)
        }
    }
}

struct BookNetworkingView_Previews: PreviewProvider {
    static var previews: some View {
        BookNetworkingView()
    }
}
