//
//  TabBarView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/24/23.
//

import SwiftUI

struct TabBarView: View {
    @State var index = 0
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                Spacer()
                switch index{
                case 0 :
                    ContentView()
                //TODO: change to different views once finish implementing
                case 1 :
                    ContentView()
                case 2:
                    ContentView()
                case 3:
                    ContentView()
                default:
                    ContentView()
                }
                
                Spacer()
                
                ZStack{
                    Rectangle()
                        .fill(Color("TabBarColor"))
                        .frame(width: geo.size.width,
                               height: geo.size.width * 0.25,
                               alignment: .bottom)
                        .cornerRadius(35, corners: [.topLeft, .topRight])
                        .padding(.top,25)
                    
                    HStack{
                        Button {
                            index = 0
                        } label: {
                            if index == 0 {
                                Image("HomeTappedIcon")
                            } else {
                                Image("HomeUntappedIcon")
                            }
                        }
                        .padding(.leading)
                        Spacer()
                        Button {
                            index = 1
                        } label: {
                            if index == 1 {
                                Image("SavedCollectionTappedIcon")
                            } else {
                                Image("SavedCollectionUntappedIcon")
                            }
                        }
                        Spacer()
                        Button {
                            index = 2
                        } label: {
                            if index == 2 {
                                Image("MessageTappedIcon")
                            } else {
                                Image("MessageUntappedIcon")
                            }
                        }
                        Spacer()
                        Button {
                            index = 3
                        } label: {
                            if index == 3 {
                                Image("ProfileTappedIcon")
                            } else {
                                Image("ProfileUntappedIcon")
                            }
                        }
                        .padding(.trailing)
                    }.padding()
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
                
            }.edgesIgnoringSafeArea(.all)
        }
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
