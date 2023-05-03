import SwiftUI
import OpenAISwift

struct ChatgptView: View {
    
    let config = AppConfig()
    let openAI: OpenAISwift
    
    @State private var search: String = ""
    @State private var questionAndAnswers: [QuestionAndAnswer] = []
    @State private var searching: Bool = false
    
    init() {
        openAI = OpenAISwift(authToken: config.OPENAI_API_KEY)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                ScrollView(showsIndicators: true) {
                   LazyVStack(spacing: 10) {
                        ForEach(questionAndAnswers) { qa in
                            if let answer = qa.answer {
                                QuestionBubble(text: qa.question)
                                AnswerBubble(text: answer)
                            } else {
                                QuestionBubble(text: qa.question)
                            }
                        }
                        
                    }
                    .padding()
                    .frame(maxHeight: 600)
                }
                
                HStack {
                    TextField("Type here...", text: $search)
                        .onSubmit {
                            if !search.isEmpty {
                                let questionAndAnswer = QuestionAndAnswer(question: search, answer: nil)
                                questionAndAnswers.append(questionAndAnswer)
                                searching = true
                                performOpenAISearch()
                            }
                        }
                        .padding()
                    if searching {
                        ProgressView()
                            .padding()
                    }
                }
                
                Spacer()
            }.navigationTitle("ChatGPT")
        }
        .padding(.top)
        .padding(.bottom, 50)
    }
    
    private func performOpenAISearch() {
        let searchText: String = search;
        search = "";
        openAI.sendCompletion(
            with: searchText,
            model: .gpt3(.davinci),
            maxTokens: 50,
            temperature: 0.5
        ) { result in
            switch result {
                case .success(let success):
                    let answer = success.choices?.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "..."
                    if let index = questionAndAnswers.firstIndex(where: { $0.question == searchText }) {
                        questionAndAnswers[index].answer = answer
                    }
                    searching = false
                case .failure(let failure):
                    print(failure.localizedDescription)
                    searching = false
            }
        }
    }
}

struct QuestionBubble: View {
    let text: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .foregroundColor(.black)
        }
    }
}

struct AnswerBubble: View {
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
                .padding()
                .background(Color.blue.opacity(0.9))
                .cornerRadius(10)
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct ChatgptView_Previews: PreviewProvider {
    static var previews: some View {
        ChatgptView()
    }
}

struct QuestionAndAnswer: Identifiable {
    let id = UUID()
    
    let question: String
    var answer: String?
}

