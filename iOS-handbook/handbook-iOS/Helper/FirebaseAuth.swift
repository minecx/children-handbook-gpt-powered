//
//  FirebaseAuth.swift
//  handbook-iOS
//
//  Created by Ann Zhou on 5/3/23.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase
import SwiftUI

struct FirebaseAuth {
    static var share = FirebaseAuth()
        
    private init() {}
    
    func signOutWithGoogle() {
        do {
            print("sign out with google...")
            try GIDSignIn.sharedInstance.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func signInWithGoogle(presenting: UIViewController, completion: @escaping (User) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { result, error in
            guard error == nil else { return }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
              return
          }
        
          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    return
                }
                UserDefaults.standard.setValue(true, forKey: "signIn")
                if let givenName = user.profile?.givenName, let familyName = user.profile?.familyName {
                    completion(User(firstName: givenName, lastName: familyName))
                }
            }
        }
    }
}
