//
//  User.swift
//  handbook-iOS
//
//  Created by Ann Zhou on 5/3/23.
//

import SwiftUI

class User: ObservableObject {
//    var uid: String?
    @Published var firstName: String
    @Published var lastName: String
//    var email: String?
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}
