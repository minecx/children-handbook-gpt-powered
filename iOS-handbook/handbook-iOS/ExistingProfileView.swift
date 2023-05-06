//
//  ExistingProfileView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/27/23.
//

import SwiftUI

struct ExistingProfileView: View {
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
        
        GeometryReader { geo in
            ZStack {
                MovingBubblesView()
                
                VStack{
                    HStack {
                        Button {
                            //TODO:
                        } label: {
                            Text("Save")
                                .font(Font.system(size: 16))
                                .bold()
                        }
                        .padding(.trailing)

                        Spacer()

                        Button {
                            UserDefaults.standard.setValue(false, forKey: "signIn")
                        } label: {
                            Text("Sign Out")
                                .font(Font.system(size: 16))
                                .bold()
                        }
                        .padding(.trailing)
                    }
                    Text("Profile")
                        .font(Font.system(size: 34, weight: .semibold))
                        .padding(.bottom, 12)
                    
                    HStack {
                        ZStack(alignment: .bottomTrailing) {
                            ZStack{
                                Circle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color("BubbleColor1"), Color("BubbleColor3")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 80, height: 80)
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
                        Text("Name")
                            .font(Font.system(size: 16))
                            .bold()
                            .padding(.bottom, 10)
                            .foregroundColor(showIndication ? .red : nil)
                        
                        TextField("Kiddo's nickname", text: $nickName)
                            .padding()
                            .padding(.leading)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(100)
                            .frame(height: 40)
                            .opacity(0.8)
                            .padding(.bottom, 20)
                            .ignoresSafeArea(.keyboard)
                    }
                    
                    HStack(alignment: .bottom){
                        Text("Date of Birth")
                            .font(Font.system(size: 16))
                            .bold()
                            .padding(.bottom, 10)
                        Spacer()
                        DatePicker("", selection: $selectedDate, in: ...Date.now, displayedComponents: .date)
                            .colorScheme(.dark)
                            .frame(height: 40)
                            .accentColor(Color("AccentColor2"))
                            .id(calendarId)
                            .onChange(of: selectedDate, perform: { _ in
                                calendarId += 1
                            })
//                            .onTapGesture {
//                                calendarId += 1
//                            }
                    }
                    .padding(.bottom)
                    
                    ZStack{
                        Rectangle()
                            .fill(.white).opacity(0.6)
                            .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.18)
                            .cornerRadius(15)
                        VStack{
                            Button {
                                //TODO:
                            } label: {
                                Capsule()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color("BubbleColor1"), Color("BubbleColor3")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.06)
                                    .overlay(Image("upload"))
                            }
                            .padding(.top)
                            
                            Text("Share your creativity")
                                .font(Font.system(size: 15, weight: .semibold))
                                .foregroundColor(Color("FontColor2"))
                            Text("By uploading the stories & pictures")
                                .font(Font.system(size: 15, weight: .semibold))
                                .foregroundColor(Color("FontColor2"))
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("OnboardingSecColor3"), style: StrokeStyle(lineWidth: 5, dash: [10]))
                                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.18)
                        )
                    }
                    .padding(.bottom)
                    .padding(.bottom)
                    
//                    Button{
//                        showIndication = nickName.isEmpty
//                    }label:{
//                        Text("Save")
//                            .bold()
//                            .frame(height: 55)
//                            .frame(maxWidth: .infinity, alignment: .center)
//                            .font(.system(size: 18))
//                            .foregroundColor(Color.white)
//                            .background(nickName == "" ? LinearGradient(gradient: Gradient(colors: [Color("FontColor2"), Color("LightGrayColor")]), startPoint: .topLeading, endPoint: .bottomTrailing) :  LinearGradient(gradient: Gradient(colors: [Color("BubbleColor1"), Color("BubbleColor3")]), startPoint: .topLeading, endPoint: .bottomTrailing))
//                            .clipShape(Capsule())
//                    }
//                    .padding(.bottom)
                    
                    Spacer()
                }
                .foregroundColor(Color("FontColor1"))
                .padding(.horizontal)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct ExistingProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ExistingProfileView()
    }
}
