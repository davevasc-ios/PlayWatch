//
//  TabBarView.swift
//  PlayWatch
//
//  Created by David on 14/4/24.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var currentTab: Tab = .home
    @Namespace private var animation
    @State private var tabShapePosition: CGPoint = .zero
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
                HomeView()
                    .tag(Tab.home)
                Text("Game")
                    .tag(Tab.game)
                Text("Favorites")
                    .tag(Tab.favorites)
                Text("Settings")
                    .tag(Tab.settings)
            }
            CustomTabBar()
        }
       
    }
    
    @ViewBuilder
    func CustomTabBar(_ tint: Color = .blue, _ inactiveTint: Color = .blue) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) {
                TabBarItem(tint: tint, inactiveTint: inactiveTint, tab: $0, animation: animation, currentTab: $currentTab, position: $tabShapePosition)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(content: {
            TabShape(midpoint: tabShapePosition.x)
                .fill(.white)
                .ignoresSafeArea()
                .shadow(color: tint.opacity(0.2), radius: 5, x: 0, y: -5)
                .blur(radius: 2)
                .padding(.top, 25)
        })
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: currentTab)
    }
    
}

struct TabBarItem: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tab
    var animation: Namespace.ID
    @Binding var currentTab: Tab
    @Binding var position: CGPoint
    @State private var tabPosition: CGPoint = .zero
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundColor(currentTab == tab ? .white : inactiveTint)
                .frame(width: currentTab == tab ? 55 : 35, height: currentTab == tab ? 55 : 35)
                .background {
                    if currentTab == tab {
                        Circle()
                            .fill(tint.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
            Text(tab.rawValue)
                .font(.caption)
                .foregroundColor(currentTab == tab ? tint : .gray)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .viewPosition(completion: { rect in
            tabPosition.x = rect.midX
            if currentTab == tab {
                position.x = rect.midX
            }
            
        })
        .onTapGesture {
            currentTab = tab
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                position.x = tabPosition.x
            }
        }
    }
}

#Preview {
    TabBarView()
}
