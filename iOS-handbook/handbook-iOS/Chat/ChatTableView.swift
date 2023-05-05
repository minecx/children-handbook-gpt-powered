//
//  ChatTableView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 5/5/23.
//

import SwiftUI
import Combine

struct ChatTableView: View {
    @StateObject var viewModel = ChatsViewModel()
    @EnvironmentObject var sharedData: SharedData
    @State private var isNewChatPresented = false

    var body: some View {
        
        NavigationView {
            List {
                ForEach(viewModel.chats) { chat in
                    ZStack{
                        ChatRow(chat: chat)
                        NavigationLink(destination: {
                            ChatView(chat: chat)
                                .environmentObject(viewModel)
                                .onAppear {
                                    sharedData.isHomeViewVisible = false
                                }
                                .onDisappear {
                                    sharedData.isHomeViewVisible = true
                                }
                        }) {
                            EmptyView()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 0)
                        .opacity(0)
                    }
                    .swipeActions {
                        if viewModel.chats.count > 1 {
                            Button {
                                viewModel.deleteChat(chat)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Chat History")
            .navigationBarItems(trailing: Button(action: {
                let newChat = Chat(messages: [])
                viewModel.chats.append(newChat)
                isNewChatPresented = true
            }, label: {
                Image(systemName: "square.and.pencil")
            }))
            .background(
                NavigationLink(destination: ChatView(chat: viewModel.chats.last!)
                                .environmentObject(viewModel)
                                .onAppear {
                                    sharedData.isHomeViewVisible = false
                                }
                                .onDisappear {
                                    sharedData.isHomeViewVisible = true
                                },
                               isActive: $isNewChatPresented) {
                    EmptyView()
                }
                .hidden()
            )
            .background(MovingBubblesView())
        }
    }
    
    func deleteChat(at offsets: IndexSet) {
        
        viewModel.chats.remove(atOffsets: offsets)
    }
}

struct ChatTableView_Previews: PreviewProvider {
    static var previews: some View {
        ChatTableView()
    }
}


