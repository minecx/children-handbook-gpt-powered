//
//  ChatgptView.swift
//  handbook-iOS
//
//  Created by Ann Zhou on 4/24/23.
//

import SwiftUI
import OpenAISwift

struct ChatgptView: View {
    
    let config = AppConfig()
    let openAI: OpenAISwift
    
    @State private var search: String = ""
    @State private var questionAndAnswers: [QuestionAndAnswer] = []
    @State private var searching: Bool = false
        
    @State private var chatMessages: [ChatMessage] = []
    
    @State private var searchStory: String = "Please write my 5 year old son a story, the response should not exceed the 300 tokens. "
        
    @State private var generatedImagesURLs: String = ""
        
    init() {
        openAI = OpenAISwift(authToken: config.OPENAI_API_KEY)
    }
    
    static let emptyScrollToString = "Empty"
    @State private var convIndex = ""
        
    var body: some View {
        VStack {
            Spacer()
            HStack{
                Spacer()
                Text("Kiddo Helper")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("FontColor1"))
                Spacer()
            }
            ScrollViewReader { anchor in
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(questionAndAnswers, id: \.id) { qa in
                            VStack(spacing: 10) {
                                HStack(alignment: .bottom) {
                                    ChatBubble(direction: .right) {
                                        Text(qa.question)
                                            .font(.system(size: 15, weight: .medium))
                                            .padding(.all, 15)
                                            .foregroundColor(Color.black)
                                            .background(Color.white).opacity(0.7)
                                    }
                                    avatarView()
                                }
                                
                                HStack(alignment: .bottom) {
                                    botAvatarView()
                                    ChatBubble(direction: .left) {
                                        Text(qa.answer ?? "Sorry, I don't understand your question.")
                                            .font(.system(size: 15, weight: .medium))
                                            .padding(.all, 15)
                                            .foregroundColor(Color.black)
                                            .background(Color("BubbleColor2")).opacity(0.7)
                                    }
                                }
                            }
                            .onChange(of: convIndex) { _ in
                                anchor.scrollTo(ChatgptView.emptyScrollToString, anchor: .bottom)
                            }
                        }
                        HStack{
                            Spacer()
                        }
                        .id(ChatgptView.emptyScrollToString)
                    }
                    
                    if searching {
                        ProgressView()
                            .padding()
                    }
                }
            }
            
            HStack{
                Button {
                    if !searchStory.isEmpty {
                        searching = true
                        performWriteStoryOpenAISearch()
                    }
                } label: {
                    Text("✏️Write a story")
                        .font(.system(size: 13))
                        .foregroundColor(Color.black)
                }
                .frame(width: 110, height: 30)
                .background(Color.white).opacity(0.7)
                .cornerRadius(15)
                
                Button {
                    //TODO: need to fix performOpenAIImageSearch()
//                    searching = true
//                    performOpenAIImageSearch()
                } label: {
                    Text("🎨 Draw a picture")
                        .font(.system(size: 13))
                        .foregroundColor(Color.black)
                }
                .frame(width: 130, height: 30)
                .background(Color.white).opacity(0.7)
                .cornerRadius(15)
                Spacer()
            }
            .padding(5)
            
            TextField("Type here...", text: $search)
                .onSubmit {
                    if !search.isEmpty {
                        searching = true
                        performOpenAISearch()
                    }
                }
                .font(.system(size: 15, weight: .medium))
                .padding(15)
                .padding(.leading)
                .background(RoundedRectangle(cornerRadius: 34).fill(Color.white).opacity(0.7))
                .frame(height: 44)
                .background(.clear)
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
        .background(MovingBubblesView())
    }
    
    //TODO: In future, we can add the Moderation layer
    private func performOpenAISearch() {
        let firstUserMessage: ChatMessage = ChatMessage(role: .user, content: search)
        chatMessages.append(firstUserMessage)
        openAI.sendChat(
            with: chatMessages,
            model: .chat(.chatgpt),
            //TODO: unique identifier, should be determined by log in information
            user: "123",
            temperature: 0.5,
            topProbabilityMass: 0.2,
            choices: 1,
            //TODO: can change this number later
            maxTokens: 300,
            presencePenalty: 0.5,
            frequencyPenalty: 0.8
            //TODO: can set the logitBias parameter later to set up the response references
        ) { result in
            switch result {
            case .success(let success):
                //for display purposes
                let qAnda = QuestionAndAnswer(question: search, answer: success.choices?.first?.message.content ?? "Sorry, I don't understand your question.")
                questionAndAnswers.append(qAnda)
                
                let botChatMessage = ChatMessage(role: .assistant, content: success.choices?.first?.message.content ?? "Sorry, I don't understand your question.")
                chatMessages.append(botChatMessage)
                search = ""
                searching = false
                convIndex.append("a")
            case .failure(let failure):
                print(failure.localizedDescription)
                print("hello")
                searching = false
            }
        }
    }
    
    private func performWriteStoryOpenAISearch() {
        //TODO: Customization here
        let firstUserMessage: ChatMessage = ChatMessage(role: .user, content: searchStory)
        chatMessages.append(firstUserMessage)
        openAI.sendChat(
            with: chatMessages,
            model: .chat(.chatgpt),
            //TODO: unique identifier, should be determined by log in information
            user: "123",
            temperature: 0.5,
            topProbabilityMass: 0.2,
            choices: 1,
            //TODO: can change this number later
            maxTokens: 300,
            presencePenalty: 0.5,
            frequencyPenalty: 0.8
            //TODO: can set the logitBias parameter later to set up the response references
        ) { result in
            switch result {
            case .success(let success):
                //for display purposes
                let qAnda = QuestionAndAnswer(question: "Write a story", answer: success.choices?.first?.message.content ?? "Sorry, I don't understand your question.")
                questionAndAnswers.append(qAnda)
                
                let botChatMessage = ChatMessage(role: .assistant, content: success.choices?.first?.message.content ?? "Sorry, I don't understand your question.")
                chatMessages.append(botChatMessage)
                searchStory = ""
                searching = false
                convIndex.append("a")
            case .failure(let failure):
                print(failure.localizedDescription)
                print("hello")
                searching = false
            }
        }
    }
    
    private func performOpenAIImageSearch() {
        let firstUserMessage: ChatMessage = ChatMessage(role: .user, content: "Generate a picture")
        chatMessages.append(firstUserMessage)
        openAI.sendImages(with: "A 3d render of a rocket ship", numImages: 1, size: .size256) { result in // Result<OpenAI, OpenAIError>
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    generatedImagesURLs = success.data?.first?.url  ?? ""
                    let botChatMessage = ChatMessage(role: .assistant, content: generatedImagesURLs)
                    chatMessages.append(botChatMessage)
                    let tt = chatMessages
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

struct ChatgptView_Previews: PreviewProvider {
    static var previews: some View {
        // this needs to be itself
        // otherwise it shows something else
        ChatgptView()
    }
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

struct ChatBubbleShape: Shape {
    enum Direction {
        case left
        case right
    }
    
    let direction: Direction
    
    func path(in rect: CGRect) -> Path {
        return (direction == .left) ? getLeftBubblePath(in: rect) : getRightBubblePath(in: rect)
    }
    
    private func getLeftBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 25, y: height))
            p.addLine(to: CGPoint(x: width - 20, y: height))
            p.addCurve(to: CGPoint(x: width, y: height - 20),
                       control1: CGPoint(x: width - 8, y: height),
                       control2: CGPoint(x: width, y: height - 8))
            p.addLine(to: CGPoint(x: width, y: 20))
            p.addCurve(to: CGPoint(x: width - 20, y: 0),
                       control1: CGPoint(x: width, y: 8),
                       control2: CGPoint(x: width - 8, y: 0))
            p.addLine(to: CGPoint(x: 21, y: 0))
            p.addCurve(to: CGPoint(x: 4, y: 20),
                       control1: CGPoint(x: 12, y: 0),
                       control2: CGPoint(x: 4, y: 8))
            p.addLine(to: CGPoint(x: 4, y: height - 11))
            p.addCurve(to: CGPoint(x: 0, y: height),
                       control1: CGPoint(x: 4, y: height - 1),
                       control2: CGPoint(x: 0, y: height))
            p.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
            p.addCurve(to: CGPoint(x: 11.0, y: height - 4.0),
                       control1: CGPoint(x: 4.0, y: height + 0.5),
                       control2: CGPoint(x: 8, y: height - 1))
            p.addCurve(to: CGPoint(x: 25, y: height),
                       control1: CGPoint(x: 16, y: height),
                       control2: CGPoint(x: 20, y: height))
            
        }
        return path
    }
    
    private func getRightBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 25, y: height))
            p.addLine(to: CGPoint(x:  20, y: height))
            p.addCurve(to: CGPoint(x: 0, y: height - 20),
                       control1: CGPoint(x: 8, y: height),
                       control2: CGPoint(x: 0, y: height - 8))
            p.addLine(to: CGPoint(x: 0, y: 20))
            p.addCurve(to: CGPoint(x: 20, y: 0),
                       control1: CGPoint(x: 0, y: 8),
                       control2: CGPoint(x: 8, y: 0))
            p.addLine(to: CGPoint(x: width - 21, y: 0))
            p.addCurve(to: CGPoint(x: width - 4, y: 20),
                       control1: CGPoint(x: width - 12, y: 0),
                       control2: CGPoint(x: width - 4, y: 8))
            p.addLine(to: CGPoint(x: width - 4, y: height - 11))
            p.addCurve(to: CGPoint(x: width, y: height),
                       control1: CGPoint(x: width - 4, y: height - 1),
                       control2: CGPoint(x: width, y: height))
            p.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
            p.addCurve(to: CGPoint(x: width - 11, y: height - 4),
                       control1: CGPoint(x: width - 4, y: height + 0.5),
                       control2: CGPoint(x: width - 8, y: height - 1))
            p.addCurve(to: CGPoint(x: width - 25, y: height),
                       control1: CGPoint(x: width - 16, y: height),
                       control2: CGPoint(x: width - 20, y: height))
            
        }
        return path
    }
}

struct ChatBubble<Content>: View where Content: View {
    let direction: ChatBubbleShape.Direction
    let content: () -> Content
    init(direction: ChatBubbleShape.Direction, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.direction = direction
    }
    
    var body: some View {
        HStack {
            if direction == .right {
                Spacer()
            }
            content().clipShape(ChatBubbleShape(direction: direction))
            if direction == .left {
                Spacer()
            }
        }
        .padding([(direction == .left) ? .leading : .trailing, .top, .bottom], 10)
        .padding((direction == .right) ? .leading : .trailing, 10)
    }
}

//TODO: need to change the user avatar according to the data passed in
struct avatarView: View {
    var body: some View {
        ZStack(alignment: .center){
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("BubbleColor1"), Color("BubbleColor3")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 30, height: 30)
            Text("🐶")
                .font(.system(size: 25))
        }
    }
}

struct botAvatarView: View {
    var body: some View {
        ZStack(alignment: .center){
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("BubbleColor1"), Color("BubbleColor3")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 30, height: 30)
            Text("🤖️")
                .font(.system(size: 25))
        }
    }
}
