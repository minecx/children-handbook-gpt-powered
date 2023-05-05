//
//  DetailedMusicView.swift
//  handbook-iOS
//
//  Created by Bob on 5/4/23.
//

import SwiftUI

struct DetailedMusicView: View {
    let music: String
    
    var body: some View {
        VStack {
            Image(music)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
            Text(music)
        }
    }
}
