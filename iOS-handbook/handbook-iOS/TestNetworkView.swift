//
//  TestNetworkView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/28/23.
//

import SwiftUI

struct TestNetworkView: View {
    @StateObject var childrenbookFetcher = ChildrenBookFetcher()

    var body: some View {
        if childrenbookFetcher.isLoading {
            LoadingView()
        } else if childrenbookFetcher.errorMessage != nil {
            ErrorView(childrenbookFetcher: childrenbookFetcher)
        } else {
            ChildrenBookListView(books: childrenbookFetcher.books)
        }
    }
}

struct TestNetworkView_Previews: PreviewProvider {
    static var previews: some View {
        TestNetworkView()
    }
}
