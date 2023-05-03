//
//  SignupView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/24/23.
//

import SwiftUI

struct SignupView: View {
    @State private var userName: String = ""
    @State private var passWord: String = ""
    @State private var isSecureField: Bool = true
    
    @State private var showLoginView: Bool = false
    
    @State private var showContentView: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                Text("Create an Account")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("FontColor1"))
                    .frame(width: geo.size.width, alignment: .center)
                    .padding(.vertical)
                    .padding(.bottom)
//                Text("Let's get started")
//                    .font(.system(size: 22, weight: .medium))
//                    .foregroundColor(Color("FontColor2"))
//                    .frame(width: geo.size.width, alignment: .center)
//                    .padding(.bottom)

                TextField("Enter your email", text: $userName)
                    .font(.system(size: 17, weight: .medium))
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color.black))

                Button {
                    //TODO:
                    showContentView = true
                } label: {
                    Text("Sign up")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.white)
                }
                .frame(width: geo.size.width, height: 60)
                .background(Color.green)
                .cornerRadius(15)
                .padding(.vertical)
                .ignoresSafeArea(.keyboard)
                //TODO: Password and Account Verification API call
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
                            FirebaseAuth.share.signInWithGoogle(presenting: getRootViewController()) { error in
                                print("ERROR: \(String(describing: error) )")
                            }
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
                        Text("Already a member?")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("FontColor2"))
                        Button {
                            showLoginView.toggle()
                        } label: {
                            Text("Log in now")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color.green)
                        }
                        .sheet(isPresented: $showLoginView) {
                            LoginView()
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


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
