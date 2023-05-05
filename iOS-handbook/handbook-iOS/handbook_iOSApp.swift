//
//  handbook_iOSApp.swift
//  handbook-iOS
//
//  Created by Bob on 4/23/23.
//

import SwiftUI

@main
struct handbook_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("signIn") var isSignIn = false
    @StateObject var userData: User = User(firstName: "First Name", lastName: "Last Name")

    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .environmentObject(userData)
            // DiscoverView()
            //     .environmentObject(userData)
        }
    }
}
