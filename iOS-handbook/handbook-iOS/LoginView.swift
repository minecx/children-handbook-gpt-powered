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
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                Text("Hello Again!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("FontColor1"))
                    .frame(width: geo.size.width, alignment: .center)
                    .padding(.vertical)
                Text("Welcome back you've")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color("FontColor1"))
                    .frame(width: geo.size.width, alignment: .center)
                Text("been missed!")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color("FontColor1"))
                    .frame(width: geo.size.width, alignment: .center)
                    .padding(.bottom)
                TextField("Enter username", text: $userName)
                    .font(.system(size: 17, weight: .medium))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                ZStack (alignment: .trailing) {
                    if isSecureField {
                        SecureField("Password", text: $passWord)
                            .font(.system(size: 17, weight: .medium))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                    } else {
                        TextField("Password", text: $passWord)
                            .font(.system(size: 17, weight: .medium))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
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
                    Text("Reset it")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.green)
                }
                .frame(width: geo.size.width, alignment: .leading)
                .padding(.bottom)
                
                Button {
                    print("Image tapped!")
                } label: {
                    Text("Log in")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.white)
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.08)
                .background(Color.green)
                .cornerRadius(15)
                .padding(.vertical)
                
                LabelledDivider(label: "or")
                
                HStack(spacing: 30){
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white).opacity(0.15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        Image("GoogleIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.08, height: geo.size.height * 0.08)
                    }
                    .frame(width: geo.size.width * 0.2, height: geo.size.height * 0.08)
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white).opacity(0.15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        Image("AppleIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.08, height: geo.size.height * 0.08)
                    }
                    .frame(width: geo.size.width * 0.2, height: geo.size.height * 0.08)
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white).opacity(0.15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        Image("FacebookIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.08, height: geo.size.height * 0.08)
                    }
                    .frame(width: geo.size.width * 0.2, height: geo.size.height * 0.08)
                }
                
                VStack{
                    Spacer()
                    HStack{
                        Text("Not a member?")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("FontColor2"))
                        Text("Register now")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color.green)
                    }
                    .frame(width: geo.size.width, alignment: .center)
                }
            }
        }
        .padding()
        .background(MovingBubblesView())
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

