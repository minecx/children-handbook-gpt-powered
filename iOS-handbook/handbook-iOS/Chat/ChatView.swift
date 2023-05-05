//
//  ChatsView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 5/5/23.
//

import SwiftUI
import OpenAISwift
import Foundation

struct ChatView: View {
    @EnvironmentObject var viewModel: ChatsViewModel
    
    let chat: Chat
    
    let config = AppConfig()
    let openAI: OpenAISwift

    init(chat: Chat) {
        self.chat = chat
        openAI = OpenAISwift(authToken: config.OPENAI_API_KEY)
    }
    
    @State private var search = ""
    @FocusState private var isFocused
    @State private var searching: Bool = false
        
    @State private var chatMessages: [ChatMessage] = []
    
    @State private var messageIDToScroll: UUID?
    
    var body: some View {
        VStack(spacing: 0){
            GeometryReader { reader in
                ScrollView {
                    ScrollViewReader { scrollReader in
                        getMessageView(viewWidth: reader.size.width)
                            .padding(.horizontal)
                            .onChange(of: messageIDToScroll) { _ in
                                if let messageID = messageIDToScroll {
                                    scrollTo(messageID: messageID, shouldAnimate: true, scrollReader: scrollReader)
                                }
                            }
                            .onAppear {
                                if let messageID = chat.messages.last?.id {
                                    scrollTo(messageID: messageID, anchor: .bottom, shouldAnimate: false, scrollReader: scrollReader)
                                }
                            }
                    }
                }
            }
            .padding(.bottom, 5)
            
            HStack{
                Button {
                    searching = true
                    performWriteStoryOpenAISearch()
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
                    searching = true
                    performOpenAIImageSearch()
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
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            toolBarView()
        }
        .padding(.top, 1)
        .navigationBarTitleDisplayMode(.inline)
        .background(MovingBubblesView())
    }
    
    func scrollTo(messageID: UUID, anchor: UnitPoint? = nil, shouldAnimate: Bool, scrollReader: ScrollViewProxy) {
        DispatchQueue.main.async {
            withAnimation(shouldAnimate ? Animation.easeIn : nil) {
                scrollReader.scrollTo(messageID, anchor: anchor)
            }
        }
    }
    
    func toolBarView() -> some View {
        VStack {
            let height: CGFloat = 37
            HStack {
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
                .focused($isFocused)
                
                if searching {
                    ProgressView()
                        .padding()
                }
                
//                Button {
//                    sendMessage()
//                    performOpenAISearch()
//                } label: {
//                    Image(systemName: "paperplane.fill")
//                        .foregroundColor(.white)
//                        .frame(width: height, height: height)
//                        .background(
//                            Circle()
//                                .foregroundColor(search.isEmpty ? Color.gray : Color.blue)
//                        )
//                }
//                .disabled(search.isEmpty)
            }
            .frame(height: height)
        }
        .padding(.vertical)
        .padding(.horizontal)
    }
    
    func sendMessage() {
        if let message = viewModel.sendMessage(search, type: .Sent, in: chat) {
            search = ""
            messageIDToScroll = message.id
        }
    }
    
    func sendMessageImage() {
        if let message = viewModel.sendMessage("Draw a picture", type: .Sent, in: chat) {
            messageIDToScroll = message.id
        }
    }
    
    func sendMessageStory() {
        if let message = viewModel.sendMessage("Write a story", type: .Sent, in: chat) {
            messageIDToScroll = message.id
        }
    }
    
    func addBotMessage(answer: String) {
        if let message = viewModel.sendMessage(answer, type: .Received, in: chat) {
            search = ""
            messageIDToScroll = message.id
        }
    }
    
    let columns = [GridItem(.flexible(minimum: 10))]
    
    func getMessageView(viewWidth: CGFloat) -> some View {
        VStack(spacing: 0) {
            ForEach(chat.messages) { message in  // Add the 'id' parameter here
                let isReceived = message.type == .Received
                HStack{
                    ZStack{
                        if !isReceived {
                            HStack(alignment: .bottom) {
                                ChatBubble(direction: .right) {
                                    Text(message.text)
                                        .font(.system(size: 15, weight: .medium))
                                        .padding(.all, 15)
                                        .foregroundColor(Color.black)
                                        .background(Color.white).opacity(0.7)
                                }
                                avatarView()
                            }
                        } else {
                            HStack(alignment: .bottom) {
                                botAvatarView()
                                ChatBubble(direction: .left) {
                                    Text(message.text)
                                        .font(.system(size: 15, weight: .medium))
                                        .padding(.all, 15)
                                        .foregroundColor(Color.black)
                                        .background(Color("BubbleColor2")).opacity(0.7)
                                }
                            }
                        }
                    }
                    .frame(width: viewWidth * 0.7, alignment: isReceived ? .leading : .trailing)
                }
                .frame(maxWidth: .infinity, alignment: isReceived ? .leading : .trailing)
            }
        }
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
                sendMessage()
                addBotMessage(answer: success.choices?.first?.message.content ?? "Sorry, I don't understand your question.")
                
                let botChatMessage = ChatMessage(role: .assistant, content: success.choices?.first?.message.content ?? "Sorry, I don't understand your question.")
                chatMessages.append(botChatMessage)
                search = ""
                searching = false
            case .failure(let failure):
                print(failure.localizedDescription)
                print("hello")
                searching = false
            }
        }
    }
    
    private func performWriteStoryOpenAISearch() {
        //TODO: Customization here
        let firstUserMessage: ChatMessage = ChatMessage(role: .user, content: "Please write my 5 year old son a story, the response should not exceed the 300 tokens. ")
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
                sendMessageStory()
                addBotMessage(answer: success.choices?.first?.message.content ?? "Sorry, I don't understand your question.")
                
                let botChatMessage = ChatMessage(role: .assistant, content: success.choices?.first?.message.content ?? "Sorry, I don't understand your question.")
                chatMessages.append(botChatMessage)
                searching = false
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
        //TODO: Customize the input prompt to generate images; current output image number is 1; size is 256x256
        openAI.sendImages(with: "an image that can be used for children's illustration book, types and styles of illustration should be suited for children under 8, Don’t be too conceptual or abstract, drawing styles include the following: Cartoon–cute or childlike, Cartoon–whacky or funny, Realistic, Whimsical, Line drawings, Stylized, Sketchy drawings, The following media are used for this children’s books illustration: Watercolor, Acrylic, Collage. Please have aesthetic.", numImages: 1, size: .size256) { result in // Result<OpenAI, OpenAIError>
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    //for display purposes
                    sendMessageImage()
                    addBotMessage(answer: success.data?.first?.url  ?? "")
                    
                    let botChatMessage = ChatMessage(role: .assistant, content: success.data?.first?.url  ?? "")
                    chatMessages.append(botChatMessage)
                    searching = false
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chat: Chat.sampleChat[0])
            .environmentObject(ChatsViewModel())
    }
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


