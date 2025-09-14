//
//  HomeView.swift
//  PlayWatch
//
//  Created by David on 14/4/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppViewModel.self) private var vm
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack (alignment: .leading) {
                    MediaSectionView(sections: vm.homeModelLogic.mediaSectionsList)
                }
            }
            .refreshable {
                vm.homeModelLogic.on(.refreshData)
            }
            .navigationTitle(Text(AppTab.home.localized))
            .navigationBarTitleDisplayMode(.automatic)
        }
        .onAppear {
            vm.homeModelLogic.on(.viewAppear)
        }
    }
}

struct MediaSectionView: View {
    let sections: [MediaSection]
    
    var body: some View {
        ForEach (sections) { section in
            LazyVStack (spacing: 0) {
                MediaTitleView(title: section.title)
                MediaFlowView(items: section.items)
            }
        }
    }
}

struct MediaTitleView: View {
    let title: LocalizedStringResource
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
    }
}

struct MediaFlowView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    let items: [Media]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 4) {
                ForEach(items) { item in
                    NavigationLink(destination: MediaDetailView(item: item)) {
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
            }
            .scrollTargetLayout()
        }
        .contentMargins(4, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
}

struct MediaDetailView: View {
    var item: Media
    
    var body: some View {
        VStack (spacing: 30) {
            HStack {
                Text("Id: ")
                Text("\(item.id)")
            }
            HStack {
                Text("Type: ")
                Text(item.type.rawValue)
            }
            HStack {
                Text("Image: ")
                Text(item.imageUrl?.absoluteString ?? "")
            }
            HStack {
                Text("Name: ")
                Text(item.name)
            }
            HStack {
                Text("Date: ")
                if let date = item.date {
                    Text(date.toString(format: .display))
                }
            }
            HStack {
                Text("Rating: ")
                Text("\(item.rating ?? .zero)")
            }
        }
    }
}

struct MediaPosterView: View {
    let item: Media
    
    var body: some View {
        CacheAsyncImage(url: item.imageUrl) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color.clear
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                        .frame(width: 50, height: 50)
                }
            case .success (let image):
                ZStack (alignment: .bottom) {
                    image
                        .resizable()
                    if item.type == .person {
                        PersonNameView(text: item.name)
                    }
                }
            case .failure (let error):
                switch error {
                case let urlError as URLError where urlError.code == .cancelled:
                    MediaPosterView(item: item)
                default:
                    EmptyPosterView(text: item.name)
                }
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

#if DEBUG
#Preview {
    HomeView()
        .environment(AppViewModel.preview)
}
#endif
