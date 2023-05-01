//
//  MovingBubblesView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/24/23.
//

import SwiftUI

struct MovingBubblesView: View {
    var body: some View {
        ZStack {
            MovingBubbleView(bubbleColor: Color("BubbleColor1"))
            MovingBubbleView(bubbleColor: Color("BubbleColor2"))
            MovingBubbleView(bubbleColor: Color("BubbleColor3"))
            MovingBubbleView(bubbleColor: Color("BubbleColor4"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .blur(radius: 200)
        .background(Color.white)
    }
}

struct MovingBubblesView_Previews: PreviewProvider {
    static var previews: some View {
        MovingBubblesView()
    }
}

struct MovingBubbleView: View {
    @State private var bubblePosition = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                                y: CGFloat.random(in: 0...UIScreen.main.bounds.height))
    @State private var bubbleSize: CGFloat = CGFloat.random(in: 200...420)
    let bubbleColor: Color
    
    var body: some View {
        Circle()
            .fill(bubbleColor)
            .frame(width: bubbleSize, height: bubbleSize)
            .position(bubblePosition)
            .onAppear {
                startAnimation()
            }
    }
    
    func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 8)) {
                bubblePosition = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                         y: CGFloat.random(in: 0...UIScreen.main.bounds.height))
                bubbleSize = CGFloat.random(in: 200...420)
            }
        }
    }
}
