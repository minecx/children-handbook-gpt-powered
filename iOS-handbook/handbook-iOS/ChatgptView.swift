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
                            
                            Text(qa.answer ?? "Sorry, I don't understand your question.")
                                .padding([.bottom], 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                    }
                }.padding()
                
                HStack {
                    TextField("Type here...", text: $search)
                        .onSubmit {
                            if !search.isEmpty {
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
        openAI.sendCompletion(
            with: search,
            model: .gpt3(.davinci),
            maxTokens: 50,
            temperature: 0.5
        ) { result in
            switch result {
                case .success(let success):
                    let questionAndAnswer = QuestionAndAnswer(question: search, answer: success.choices?.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Sorry, I don't understand your question.")
                    questionAndAnswers.append(questionAndAnswer)
                    search = ""
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
        ContentView()
    }
}

struct QuestionAndAnswer: Identifiable {
    let id = UUID()
    
    let question: String
    var answer: String?
}
