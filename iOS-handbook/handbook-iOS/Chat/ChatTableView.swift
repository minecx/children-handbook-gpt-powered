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
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Chat History")
            .navigationBarItems(trailing: Button(action: {
                //TODO:
            }, label: {
                Image(systemName: "square.and.pencil")
            }))
        }
    }
}

struct ChatTableView_Previews: PreviewProvider {
    static var previews: some View {
        ChatTableView()
    }
}
