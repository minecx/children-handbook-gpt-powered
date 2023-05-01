//
//  LoginView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/24/23.
//

import SwiftUI

struct LoginView: View {
    @State private var userName: String = ""
    @State private var passWord: String = ""
    @State private var isSecureField: Bool = true
    
    @State private var showSignupView: Bool = false
    
    @State private var showContentView: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                Text("Welcome back!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("FontColor1"))
                    .frame(width: geo.size.width, alignment: .center)
                    .padding(.vertical)
                TextField("Enter username", text: $userName)
                    .font(.system(size: 17, weight: .medium))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color.black))
                ZStack (alignment: .trailing) {
                    if isSecureField {
                        SecureField("Password", text: $passWord)
                            .font(.system(size: 17, weight: .medium))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.black))
                    } else {
                        TextField("Password", text: $passWord)
                            .font(.system(size: 17, weight: .medium))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.black))
                    }
                    Image(isSecureField ? "PasswordHideIcon" : "PasswordShowIcon")
                        .onTapGesture {
                            isSecureField.toggle()
                        }
                        .padding()
                        .padding()
                }
                HStack{
                    Text("Forgot password?")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("FontColor2"))
                    Button {
                        //TODO: reset password api call
                    } label: {
                        Text("Reset it")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color.green)
                    }
                }
                .frame(width: geo.size.width, alignment: .leading)
                .padding(.bottom)
                
                Button {
                    //TODO: Password and Account verification API call
                    showContentView = true
                } label: {
                    Text("Log in")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.white)
                }
                .frame(width: geo.size.width, height: 60)
                .ignoresSafeArea(.keyboard)
                .background(Color.green)
                .cornerRadius(15)
                .padding(.vertical)
                .fullScreenCover(isPresented: $showContentView, content: {
                    ContentView()
                })
                
                LabelledDivider(label: "or")
                
                HStack(spacing: 30){
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white).opacity(0.15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        Button {
                            //TODO:
                        } label: {
                            Image("GoogleIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.08, height: geo.size.height * 0.08)
                        }
                    }
                    .frame(width: geo.size.width * 0.2, height: geo.size.height * 0.08)
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white).opacity(0.15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        Button {
                            //TODO:
                        } label: {
                            Image("AppleIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.08, height: geo.size.height * 0.08)
                        }
                    }
                    .frame(width: geo.size.width * 0.2, height: geo.size.height * 0.08)
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white).opacity(0.15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        Button {
                            //TODO:
                        } label: {
                            Image("FacebookIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.08, height: geo.size.height * 0.08)
                        }
                    }
                    .frame(width: geo.size.width * 0.2, height: geo.size.height * 0.08)
                }
                
                VStack{
                    Spacer()
                    HStack{
                        Text("Not a member?")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("FontColor2"))
                        Button {
                            showSignupView.toggle()
                        } label: {
                            Text("Register now")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color.green)
                        }
                        .sheet(isPresented: $showSignupView) {
                            SignupView()
                                .presentationDetents([.large])
                                .presentationDragIndicator(.visible)
                        }
                    }
                    .frame(width: geo.size.width, alignment: .center)
                }
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct LabelledDivider: View {
    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(label: String, horizontalPadding: CGFloat = 20, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack {
            line
            Text(label).foregroundColor(color)
            line
        }
    }

    var line: some View {
        VStack { Divider().background(color) }.padding(horizontalPadding)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
