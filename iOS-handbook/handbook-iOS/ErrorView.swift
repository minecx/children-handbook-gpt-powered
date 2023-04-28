//
//  ErrorView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/28/23.
//

import SwiftUI

struct ErrorView: View {
    @ObservedObject var childrenbookFetcher: ChildrenBookFetcher
    
    var body: some View {
        Text(childrenbookFetcher.errorMessage ?? "Unknown Error")
    }
}


struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(childrenbookFetcher: ChildrenBookFetcher())
    }
}
