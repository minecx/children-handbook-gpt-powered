//
//  ContentView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/26/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .discover
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack{
            VStack{
                TabView(selection: $selectedTab) {
                    switch selectedTab {
                    case .discover:
                        //TODO: Show discover view
                        DiscoverView()
                    case .collection:
                        //TODO: Show collection view
                        DiscoverView()
                    case .chat:
                        ChatgptView()
                    case .profile:
                        ExistingProfileView()
                    default:
                        //TODO: Show discover view
                        DiscoverView()
                    }
                }
            }
            VStack{
                Spacer()
                HomeView(selectedTab: $selectedTab)
                    .padding(.bottom, -34) // << this one
                    .ignoresSafeArea(.keyboard)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
