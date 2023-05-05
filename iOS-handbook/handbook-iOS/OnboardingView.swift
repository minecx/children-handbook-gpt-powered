//
//  OnboardingView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/24/23.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var backgroundOffset: CGFloat = 0
    
    @State private var showSignupView:Bool = false
    @State private var showLoginView:Bool = false
    
    @EnvironmentObject var userData: User
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0){
                VStack{
                    Image("OnboardingPicture1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.4)
                        .background(Color("OnboardingPrimaryColor1"))
                        .cornerRadius(34)
                        .shadow(radius: 3)
                    Text("Interactive")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("FontColor1"))
                        .frame(width: geo.size.width)
                    Text("AI Learning")
                        .font(.system(size: 28, weight: .bold))
                        .frame(width: geo.size.width)
                        .foregroundColor(Color("FontColor1"))
                        .padding(.bottom, 10)
                    Text("Explore all the exiting audio")
                        .frame(width: geo.size.width)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color("FontColor2"))
                    Text("books based on your interest And goal")
                        .frame(width: geo.size.width)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color("FontColor2"))
                }
                
                VStack{
                    Image("OnboardingPicture2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.4)
                        .background(Color("OnboardingPrimaryColor2"))
                        .cornerRadius(34)
                        .shadow(radius: 3)
                    Text("Develop")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("FontColor1"))
                        .frame(width: geo.size.width)
                    Text("Musicality for Kids")
                        .font(.system(size: 28, weight: .bold))
                        .frame(width: geo.size.width)
                        .foregroundColor(Color("FontColor1"))
                        .padding(.bottom, 10)
                    Text("Explore all the exiting audio")
                        .frame(width: geo.size.width)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color("FontColor2"))
                    Text("books based on your interest And goal")
                        .frame(width: geo.size.width)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color("FontColor2"))
                }
                
                VStack{
                    Image("OnboardingPicture3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.4)
                        .background(Color("OnboardingPrimaryColor3"))
                        .cornerRadius(34)
                        .shadow(radius: 3)
                    Text("Discover")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("FontColor1"))
                        .frame(width: geo.size.width)
                    Text("Exciting Audio Books")
                        .font(.system(size: 28, weight: .bold))
                        .frame(width: geo.size.width)
                        .foregroundColor(Color("FontColor1"))
                        .padding(.bottom, 10)
                    Text("Explore all the exiting audio")
                        .frame(width: geo.size.width)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color("FontColor2"))
                    Text("books based on your interest And goal")
                        .frame(width: geo.size.width)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color("FontColor2"))
                }
            }
            .frame(height: geo.size.height * 0.6)
            .offset(x: -(self.backgroundOffset * geo.size.width))
            .animation(Animation.easeInOut(duration: 0.5), value: -(self.backgroundOffset * geo.size.width))
            .gesture(
                DragGesture()
                    .onEnded({ value in
                        if value.translation.width > 10 {
                            if self.backgroundOffset > -2 {
                                self.backgroundOffset -= 1
                            }
                        } else if value.translation.width < -10 {
                            if self.backgroundOffset < 2 {
                                self.backgroundOffset += 1
                            }
                        }
                    })
            )
            HStack{
                Circle()
                    .fill(self.backgroundOffset == 0 ? Color("OnboardingSecColor1") : Color.white.opacity(0.6))
                    .frame(width: self.backgroundOffset == 0 ? 15: 12, height: self.backgroundOffset == 0 ? 15 : 12)
                
                Circle()
                    .fill(self.backgroundOffset == 1 ? Color("OnboardingSecColor2") : Color.white.opacity(0.6))
                    .frame(width: self.backgroundOffset == 1 ? 15: 12, height: self.backgroundOffset == 1 ? 15 : 12)
                
                Circle()
                    .fill(self.backgroundOffset == 2 ? Color("OnboardingSecColor3") : Color.white.opacity(0.6))
                    .frame(width: self.backgroundOffset == 2 ? 15: 12, height: self.backgroundOffset == 2 ? 15 : 12)
            }
            .animation(Animation.easeInOut(duration: 0.5), value: -(self.backgroundOffset * geo.size.width))
            .position(x: geo.size.width/2, y: geo.size.height * 0.65)
            
            Spacer()
            
            ZStack(alignment: .center){
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white).opacity(0.15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white, lineWidth: 2)
                    )
                HStack(spacing: 0){
                    Button {
                        showSignupView.toggle()
                    } label: {
                        Text("Sign up")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(Color("FontColor1"))
                            .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.08)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                    }
                    .sheet(isPresented: $showSignupView) {
                        SignupView()
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.visible)
                            .environmentObject(userData)
                    }
                    
                    Button {
                        showLoginView.toggle()
                    } label: {
                        Text("Log in")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(Color("FontColor1"))
                            .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.08)
                    }
                    .sheet(isPresented: $showLoginView) {
                        LoginView()
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                            .environmentObject(userData)
                    }
                }
            }
            .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.08, alignment: .center)
            .position(x: geo.size.width/2, y: geo.size.height * 0.9)
        }
        .background(MovingBubblesView())
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
