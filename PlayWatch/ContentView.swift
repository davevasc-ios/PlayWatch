//
//  ContentView.swift
//  PlayWatch
//
//  Created by David on 17/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack  {
                    ForEach (viewModel.mediaSectionsList) { section in
                        MediaSectionView(title: section.title, items: section.items)
                    }
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .task {
            try? await viewModel.start()
        }
    }
}

struct MediaSectionView: View {
    let title: String
    let items: [Media]
    var body: some View {
        VStack (spacing: 0) {
            MediaTitleView(title: title)
            MediaFlowView(items: items)
        }
    }
}

struct MediaTitleView: View {
    let title: String
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.custom("Futura", size: 24))
            .fontWeight(.heavy)
            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
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
        AsyncImage(url: MovieDB.imageUrl(file: item.mediaImage, size: .medium)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success (let image):
                ZStack (alignment: .bottom) {
                    image
                        .resizable()
                    if item.media == .person {
                        PersonNameView(text: item.mediaName)
                    }
                }
            case .failure:
                EmptyPosterView(text: item.mediaName)
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

struct PersonNameView: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.title3)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
            .background(Color.random
                .gradient
                .opacity(0.5))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 8, trailing: 4))
    }
}
        
struct EmptyPosterView: View {
    let text: String
    var body: some View {
        ZStack (alignment: .bottom) {
            Rectangle()
                .foregroundStyle(Color.systemRandom.gradient)
                .opacity(0.5)
            TitleNameView(text: text)
        }
    }
}

struct TitleNameView: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.title2)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
            .background(Color.random
                .gradient
                .opacity(0.5))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 8, trailing: 4))
    }
}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
