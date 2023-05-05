//
//  ChatRow.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 5/5/23.
//

import SwiftUI

struct ChatRow: View {
    let chat: Chat
    
    var body: some View {
        HStack(alignment: .top, spacing: 5){
            ZStack(alignment: .center){
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("BubbleColor1"), Color("BubbleColor3")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 50, height: 50)
                Text("🤖️")
                    .font(.system(size: 45))
            }
            Spacer()
            Text(chat.messages.last?.text ?? "")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(chat.messages.last?.date.descriptiveString() ?? "")
                .font(.system(size: 14, weight: .semibold))
        }
        .frame(height: 60)
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chat: Chat.sampleChat[1])
    }
}
