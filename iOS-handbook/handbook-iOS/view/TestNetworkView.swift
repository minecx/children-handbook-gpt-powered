//
//  TestNetworkView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/28/23.
//

import SwiftUI

struct TestNetworkView: View {
    @StateObject var breedFetcher = BreedFetcher()

    var body: some View {
        if breedFetcher.isLoading {
            LoadingView()
        } else if breedFetcher.errorMessage != nil {
            ErrorView(breedFetcher: breedFetcher)
        } else {
            BreedListView(breeds: breedFetcher.breeds)
        }
    }
}

struct TestNetworkView_Previews: PreviewProvider {
    static var previews: some View {
        TestNetworkView()
    }
}
