//
//  TestView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/24/23.
//

import SwiftUI

struct TestView: View {
    var index: Int
    
    var body: some View {
        Text("Hello, World! \(index)")
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(index: 0)
    }
}
