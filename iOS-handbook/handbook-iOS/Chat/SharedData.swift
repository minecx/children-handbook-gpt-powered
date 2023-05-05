//
//  SharedData.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 5/5/23.
//
import Combine
import SwiftUI

class SharedData: ObservableObject {
    @Published var isHomeViewVisible: Bool = true
}
