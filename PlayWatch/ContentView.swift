//
//  ContentView.swift
//  PlayWatch
//
//  Created by David on 17/3/24.
//

import SwiftUI

struct ContentView: View {
    
    var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 0) {
                    Text("En cine ahora")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("Futura", size: 24))
                        .fontWeight(.heavy)
                        .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
//                        .background(.cyan)
                    MediaFlowView(items: viewModel.cinemaPlayingList)
//                        .background(.yellow)
                    MediaFlowView(items: viewModel.cinemaUpcomingList)
                }
                .navigationTitle("Home")
            }
        }
        .task {
            try? await viewModel.start()
        }
    }
}


struct MediaFlowView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    let items: [Media]
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            LazyHStack (spacing: 4) {
                ForEach (items) { item in
                    MediaPosterView(item: item)
                    .containerRelativeFrame(.horizontal,
                                            count: verticalSizeClass == .regular ? 3 : 8,
                                            spacing: 4)
                    
                    .scrollTransition(topLeading: .interactive,
                                      bottomTrailing: .interactive,
                                      axis: .horizontal) { effect, phase in
                        effect
                            .opacity(phase.isIdentity ? 1.0 : 0.2)
                            .scaleEffect(x: phase.isIdentity ? 1.0 : 0.6,
                                         y: phase.isIdentity ? 1.0 : 0.6)
                            .offset(y: phase.isIdentity ? 0 : 50)
                            .rotation3DEffect(.degrees(abs(phase.value - 0.1) * 40),
                                              axis: (x: 0.2, y: 1, z: 0), anchor: .leading)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(4, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
}


struct MediaPosterView: View {
    let item: Media
    var body: some View {
        AsyncImage(url: MovieDB.imageUrl(file: item.posterPath, size: .medium)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success (let image):
                image
                    .resizable()
            case .failure:
                Image(systemName: "film")
                    .resizable()
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .cornerRadius(10)
        .shadow(radius: 4, y: 4)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 0))
    }
}






#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
