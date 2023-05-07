//
//  BookErrorView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 5/5/23.
//

import SwiftUI

struct BookErrorView: View {
    @ObservedObject var bookFetcher: BookFetcher
    
    var body: some View {
        VStack{
            Text("😢")
                .font(.system(size: 80))
            
            Text(bookFetcher.errorMessage ?? "")
            
            Button {
                bookFetcher.fetchAllBooks()
            } label: {
                Text("Try Again")
            }

        }
    }
}

struct BookErrorView_Previews: PreviewProvider {
    static var previews: some View {
        BookErrorView(bookFetcher: BookFetcher())
    }
}
