//
//  handbook_iOSApp.swift
//  handbook-iOS
//
//  Created by Bob on 4/23/23.
//

import SwiftUI

@main
struct handbook_iOSApp: App {
    var sharedData = SharedData()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("signIn") var isSignIn = false
    @StateObject var userData: User = User(firstName: "User", lastName: "Last Name")

    var body: some Scene {
        WindowGroup {
            if !isSignIn {
                OnboardingView()
                    .environmentObject(userData)
                    .environmentObject(sharedData)
            } else {
                ContentView()
                    .environmentObject(userData)
                    .environmentObject(sharedData)
            }
        }
    }
}
