//
//  HomeView.swift
//  handbook-iOS
//
//  Created by Bob on 4/24/23.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case discover
    case collection
    case chat
    case profile
}

struct HomeView: View {
    @Binding var selectedTab: Tab
    private var fillImage:String {
        selectedTab.rawValue + ".fill"
    }
    var body: some View {
        VStack{
            HStack{
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(selectedTab == tab ? fillImage : tab.rawValue)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                        .frame(width: 24, height: 24)
                    Spacer()
                }
            }
            .frame(width: nil, height: 78)
            .background(Color("TabBarColor"))
            .cornerRadius(30, corners: [.topLeft, .topRight])
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(.discover))
    }
}

struct RoundedCorners: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CornerRadiusModifier: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    func body(content: Content) -> some View {
        content
            .clipShape(RoundedCorners(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        self.modifier(CornerRadiusModifier(radius: radius, corners: corners))
    }
}
