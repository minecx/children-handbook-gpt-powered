//
//  Chat.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 5/5/23.
//

import Foundation
import OpenAISwift
import SwiftUI

struct Chat: Identifiable {
    let id = UUID()
    var messages: [Message]
}

struct Message: Identifiable {
    
    enum MessageType {
        case Sent, Received
    }
    
    let id = UUID()
    let date: Date
    let text: String
    let type: MessageType
    
    init(_ text: String, type: MessageType, date: Date) {
        self.date = date
        self.type = type
        self.text = text
    }
    
    init(_ text: String, type: MessageType) {
        self.init(text, type: type, date: Date())
    }
}

extension Chat {
    static let sampleChat = [
        Chat(messages: [
            Message("Why is the sky blue?", type: .Sent, date: Date(timeIntervalSinceNow: -86400*3)),
            Message("Sunlight reaches Earth's atmosphere and is scattered in all directions by all the gases and particles in the air. Blue light is scattered more than the other colors because it travels as shorter, smaller waves.", type: .Received, date: Date(timeIntervalSinceNow: -86400*3)),
            Message("Why is the grass green?", type: .Sent, date: Date(timeIntervalSinceNow: -86400*2)),
            Message("Grass is green because of the presence of chlorophyll throughout the leaves and stems.", type: .Received, date: Date(timeIntervalSinceNow: -86400*2)),
        ]),
        Chat(messages: [
            Message("Hi what books do you recommend for a 5 year old boy?", type: .Sent, date: Date(timeIntervalSinceNow: -86400*5)),
            Message("1. The Day the Crayons Quit. 2. Giraffes Can’t Dance. 3. Ice Cream Soup", type: .Received, date: Date(timeIntervalSinceNow: -86400*5)),
            Message("Who is the author of the first book?", type: .Sent, date: Date(timeIntervalSinceNow: -86400*2)),
            Message("Drew Daywalt", type: .Received, date: Date(timeIntervalSinceNow: -86400*2)),
            Message("Who is the author of the second book?", type: .Sent, date: Date()),
            Message("The author of the second book is Giles Andreae.", type: .Received, date: Date()),
        ]),
    ]
}

struct QuestionAndAnswer: Hashable {
    let id = UUID()
    
    let question: String
    var answer: String?
}

func convertChatToQuestionAndAnswer(chat: [ChatMessage]) -> [QuestionAndAnswer] {
    var questionAndAnswer: [QuestionAndAnswer] = []
    
    for i in 0..<chat.count {
        if chat[i].role == .user {
            // If this message is from the user, create a new QuestionAndAnswer object with the question
            questionAndAnswer.append(QuestionAndAnswer(question: chat[i].content, answer: nil))
        } else if chat[i].role == .assistant {
            // If this message is from the assistant, find the last QuestionAndAnswer object in the list and add the answer to it
            questionAndAnswer[questionAndAnswer.count - 1].answer = chat[i].content
        }
    }
    return questionAndAnswer
}

