//
//  ChatgptView.swift
//  handbook-iOS
//
//  Created by Ann Zhou on 4/24/23.
//
// Ref: https://www.youtube.com/watch?v=XF8IbrNh7E0&list=PLK0S7kvEbHhm3qbf9eA_fUTCdmGHcHqWl&index=1&ab_channel=azamsharp

import SwiftUI
import OpenAISwift

struct ChatgptView: View {
    
    let config = AppConfig()
    let openAI: OpenAISwift
    
    @State private var search: String = ""
    @State private var questionAndAnswers: [QuestionAndAnswer] = []
    @State private var searching: Bool = false
    
    @State private var searchFixedQuery: String = ""
    
    
    init() {
        openAI = OpenAISwift(authToken: config.OPENAI_API_KEY)
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                VStack {
                    HStack{
                        Text("Kiddo Helper")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color("FontColor1"))
                    }
                    ZStack(alignment: .bottom) {
                        ScrollView(showsIndicators: false) {
                            ForEach(questionAndAnswers) { qa in
                                VStack(spacing: 10) {
                                    HStack{
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
                                        if searching {
                                            ProgressView()
                                                .padding()
                                        } else {
                                            ChatBubble(direction: .left) {
                                                Text(qa.answer ?? "Sorry, I don't understand your question.")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .padding(.all, 15)
                                                    .foregroundColor(Color.black)
                                                    .background(Color("BubbleColor2")).opacity(0.7)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        VStack{
                            HStack{
                                Button {
                                    //TODO: adjust the search query accordingly
                                    searchFixedQuery = "Write a short story for my 5 years old child, reformat the answer with Proximate length of the story, Title:, Author:"
                                    performFixedOpenAISearch()
                                } label: {
                                    Text("✏️Write a story")
                                        .font(.system(size: 13))
                                        .foregroundColor(Color.black)
                                }
                                .frame(width: 110, height: 30)
                                .background(Color.white).opacity(0.7)
                                .cornerRadius(15)
                                
                                Button {
                                    //TODO: adjust the search query accordingly
                                } label: {
                                    Text("🎨 Draw a picture")
                                        .font(.system(size: 13))
                                        .foregroundColor(Color.black)
                                }
                                .frame(width: 130, height: 30)
                                .background(Color.white).opacity(0.7)
                                .cornerRadius(15)
                                Spacer()
                                Spacer()
                            }
                            .padding(.leading)
                            
                            HStack {
                                TextField("Type here...", text: $search)
                                    .onSubmit {
                                        if !search.isEmpty {
                                            searching = true
                                            performOpenAISearch()
                                        }
                                    }
                                    .font(.system(size: 15, weight: .medium))
                                    .padding()
                                    .padding(.leading)
                                    .background(RoundedRectangle(cornerRadius: 34).fill(Color.white).opacity(0.7))
                                if searching {
                                    ProgressView()
                                        .padding()
                                }
                            }
                            .background(.clear)
                        }
                    }
                }
                .padding()
                .background(MovingBubblesView())
            }
        }
    }
    
    private func performOpenAISearch() {
        openAI.sendCompletion(
            with: search.trimmingCharacters(in: .whitespacesAndNewlines),
            model: .gpt3(.davinci),
            maxTokens: 200,
            temperature: 0.5
        ) { result in
            switch result {
            case .success(let success):
                let questionAndAnswer = QuestionAndAnswer(question: search.trimmingCharacters(in: .whitespacesAndNewlines), answer: success.choices?.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Sorry, I don't understand your question.")
                questionAndAnswers.append(questionAndAnswer)
                search = ""
                searching = false
            case .failure(let failure):
                print(failure.localizedDescription)
                searching = false
            }
        }
    }
    
    private func performFixedOpenAISearch() {
        openAI.sendCompletion(
            with: searchFixedQuery.trimmingCharacters(in: .whitespacesAndNewlines),
            model: .gpt3(.davinci),
            maxTokens: 200,
            temperature: 0.5
        ) { result in
            switch result {
            case .success(let success):
                let questionAndAnswer = QuestionAndAnswer(question: "✏️Write a story", answer: success.choices?.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Sorry, I don't understand your question.")
                questionAndAnswers.append(questionAndAnswer)
                searchFixedQuery = ""
                searching = false
            case .failure(let failure):
                print(failure.localizedDescription)
                searching = false
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

struct QuestionAndAnswer: Identifiable {
    let id = UUID()
    
    let question: String
    var answer: String?
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
        }.padding([(direction == .left) ? .leading : .trailing, .top, .bottom], 10)
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
