//
//  ContentView.swift
//  PlayWatch
//
//  Created by David on 17/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var viewModel = HomeViewModel()
    
    @State var result = "result"
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView (.horizontal, showsIndicators: false) {
                    LazyHStack (spacing: 4) {
                        ForEach (viewModel.cinemaPlayingList) { item in
                            AsyncImage(url: MovieDB.imageUrl(file: item.posterPath, size: .medium)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success (let image):
                                    image
                                        .resizable()
                                case .failure:
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                            .containerRelativeFrame(.horizontal,
                                                    count: verticalSizeClass == .regular ? 3 : 8,
                                                    spacing: 4)
                            .shadow(radius: 10, y: 10)
                            .scrollTransition(topLeading: .interactive,
                                              bottomTrailing: .interactive,
                                              axis: .horizontal) { effect, phase in
                                effect
                                    .opacity(phase.isIdentity ? 1.0 : 0.2)
                                    .scaleEffect(x: phase.isIdentity ? 1.0 : 0.6,
                                                 y: phase.isIdentity ? 1.0 : 0.6)
                                    .offset(y: phase.isIdentity ? 0 : 50)
                                    .rotation3DEffect(.degrees(abs(phase.value) * 90),
                                                      axis: (x: 1, y: 1, z: 0), anchor: .leading)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(4, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)

                
                            
                
            }
            .navigationTitle("Home")
        }
        .task {
            try? await viewModel.start()
        }
    }
}


struct CoverFlowView<Content: View, Item: RandomAccessCollection>: View where
Item.Element: Identifiable {
    var itemWidth: CGFloat
    var items: Item
    var rotation: Double
    var content: (Item.Element) -> Content
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach (items) { item in
                    content(item)
                        .frame(width: itemWidth)
                        .scrollTransition { effect, phase in
                            effect
                                .opacity(phase.isIdentity ? 1.0 : 0.5)
                                .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3,
                                             y: phase.isIdentity ? 1.0 : 0.3)
                                .offset(y: phase.isIdentity ? 0 : 50)
                        }
//                        .visualEffect { content, geometryProxy in
//                            content
//                                .rotation3DEffect(.init(degrees: rotation(geometryProxy)),
//                                                  axis: (x: 0, y: 5, z: 0), anchor: .leading)
//                        }
                    
                }
                
            }
        }
        .contentMargins(2, for: .scrollContent)
        
    }
    func rotation(_ proxy: GeometryProxy) -> Double {
        let scrollViewWidth = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        let midX = proxy.frame(in: .scrollView(axis: .horizontal)).midX
        let progress = midX / scrollViewWidth
        let cappedProgress = max(min(progress, 1), 0)
        return cappedProgress * rotation
    }
}

struct CoverFlowItem: Identifiable {
    let id: UUID = .init()
    var media: Media
}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
