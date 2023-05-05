//
//  ChatsViewModel.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 5/5/23.
//

import Foundation

class ChatsViewModel: ObservableObject {
    @Published var chats = Chat.sampleChat

    func sendMessage(_ text: String, type: Message.MessageType, in chat: Chat) -> Message? {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            let message = Message(text, type: type)
            chats[index].messages.append(message)
            return message
        }
        return nil
    }
    
    func deleteChat(_ chat: Chat) {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats.remove(at: index)
        }
    }
}
