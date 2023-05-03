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

struct FirebaseAuth {
    static var share = FirebaseAuth()
    
    var userData = User(firstName: "Userrr")
    
    private init() {}
    
    func signInWithGoogle(presenting: UIViewController, completion: @escaping(Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { result, error in
          guard error == nil else {
              completion(error)
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
              completion(error)
              return
          }
            
            FirebaseAuth.share.userData.firstName = user.profile?.givenName ?? ""
            FirebaseAuth.share.userData.lastName = user.profile?.familyName ?? ""

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    return
                }
                UserDefaults.standard.setValue(true, forKey: "signIn")
                print("sign in with google...", user.profile?.givenName ?? "unknown")
            }
        }
    }
}
