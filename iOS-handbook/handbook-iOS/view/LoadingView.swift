//
//  LoadingView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/28/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack{
            Text("🐶")
                .font(.system(size: 80))
            ProgressView()
            Text("Getting the breeds...")
                .foregroundColor(.gray)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
