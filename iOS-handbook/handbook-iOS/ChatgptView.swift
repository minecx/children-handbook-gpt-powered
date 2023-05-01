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
                ScrollView(showsIndicators: false) {
                    ForEach(questionAndAnswers) { qa in
                        VStack(spacing: 10) {
                            Text(qa.question)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(qa.answer ?? "...")
                                .padding([.bottom], 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                    }
                }.padding()
                
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
            }.navigationTitle("ChatGPT")
        }
    }
    
    private func performOpenAISearch() {
        var searchText: String = search;
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

