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
                ZStack {
                    Color.systemRandom.ignoresSafeArea() // Background color
                        VStack { // Center vertically and horizontally
                            Spacer() // Push text to the bottom
                            Text("🎲 coming soon 🃏")
                                .font(.title) // Adjust font size as needed
                                .fontWeight(.bold) // Adjust font weight as needed
                                .foregroundColor(.white) // Adjust text color as needed
                            Spacer() // Push text to the top
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the entire ZStack
                        .ignoresSafeArea() // Extend content to safe area edges  
                }
                    .tag(Tab.game)
                Color.systemRandom.ignoresSafeArea()
                    .tag(Tab.favorites)
                Color.systemRandom.ignoresSafeArea()
                    .tag(Tab.settings)
            }
            CustomTabBar()
        }
       
    }
    
    @ViewBuilder
    func CustomTabBar(_ itemBackgroundDiameter: CGFloat = 55, _ tint: Color = .blue, _ inactiveTint: Color = .blue) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) {
                TabBarItem(diameter: itemBackgroundDiameter, tint: tint, inactiveTint: inactiveTint, tab: $0, animation: animation, currentTab: $currentTab, position: $tabShapePosition)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 0)
        .background(content: {
            
            TabShape(midpoint: tabShapePosition.x, diameter: itemBackgroundDiameter)
                .fill(.white)
                .ignoresSafeArea()
                .shadow(color: tint.opacity(0.6), radius: 5, x: 0, y: -5)
                .blur(radius: 2)
        })
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: currentTab)
    }
    
}

struct TabBarItem: View {
    var diameter: CGFloat
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
                .frame(width: currentTab == tab ? diameter : diameter - 20, height: currentTab == tab ? diameter : diameter - 20)
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
            // TODO: no funciona esta animación.
            withAnimation(.easeInOut) {
                currentTab = tab
            }
            
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                position.x = tabPosition.x
            }
        }
    }
}

#Preview {
    TabBarView()
}
