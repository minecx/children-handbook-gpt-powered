//
//  CreateProfileView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/26/23.
//

import SwiftUI

struct CreateProfileView: View {
    
    @State private var nickName: String = ""

    @State var selectedDate: Date = Date()
        
    @State private var calendarId: Int = 0
    
    let cuteAnimalEmojis = ["🐶", "🐽", "🐰", "🐼", "🐻", "🐨", "🐷", "🐿️", "🦀️", "🐒", "🐥", "🐹", "🐝"]
    @State private var generatedEmoji: String = "🐤"
    init() {
        generatedEmoji = cuteAnimalEmojis.randomElement() ?? ""
    }
    var randomEmoji: String {
        return cuteAnimalEmojis.randomElement() ?? "🐤"
    }
   
    @State private var showIndication: Bool = false
    
    var body: some View {
        
        ZStack {
            MovingBubblesView()
            
            VStack{
                Text("Create a profile")
                    .font(Font.system(size: 34, weight: .semibold))
                    .padding(.bottom, 12)
                    .padding(.top)
                Text("You’ll be able to modify it later")
                    .font(Font.system(size: 14))
                    .padding(.bottom, 17)
                HStack {
                    ZStack(alignment: .bottomTrailing) {
                        ZStack{
                            Circle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color("BubbleColor1"), Color("BubbleColor3")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 100, height: 100)
                            Text(generatedEmoji)
                                .font(.system(size: 50))
                        }
                        
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 25)
                            Button {
                                generatedEmoji = cuteAnimalEmojis.randomElement() ?? "🤔"
                            } label: {
                                Image("refresh.black")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18)
                            }
                        }
                    }
                }
            .padding(.horizontal, 20)

                VStack(alignment: .leading) {
                    Text("Name *")
                        .font(Font.system(size: 16))
                        .bold()
                        .padding(.bottom, 16)
                        .foregroundColor(showIndication ? .red : nil)
                    
                    TextField("Kiddo's nickname", text: $nickName)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(100)
                        .frame(height: 50)
                        .opacity(0.8)
                        .padding(.bottom, 20)
                }
                
                VStack(alignment: .leading) {
                    HStack{
                        Text("Date of Birth")
                            .font(Font.system(size: 16))
                            .bold()
                            .padding(.bottom, 16)
                        Spacer()
                        DatePicker("", selection: $selectedDate, in: ...Date.now, displayedComponents: .date)
                            .colorScheme(.dark)
                            .frame(height: 50)
                            .padding(.bottom, 20)
                            .accentColor(Color("AccentColor2"))
                            .id(calendarId)
                            .onChange(of: selectedDate, perform: { _ in
                              calendarId += 1
                            })
                            .onTapGesture {
                              calendarId += 1
                            }
                    }
                }
                Spacer()
            
                Button{
                    showIndication = nickName.isEmpty
                }label:{
                    Text("Next")
                        .bold()
                        .frame(height: 55)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 18))
                        .foregroundColor(Color.white)
                        .background(nickName == "" ? LinearGradient(gradient: Gradient(colors: [Color("FontColor2"), Color("LightGrayColor")]), startPoint: .topLeading, endPoint: .bottomTrailing) :  LinearGradient(gradient: Gradient(colors: [Color("BubbleColor1"), Color("BubbleColor3")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .clipShape(Capsule())
                }
                .padding(.bottom)
            }
            .foregroundColor(Color("FontColor1"))
            .padding(.horizontal)
        }
    }
}

struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileView()
    }
}
