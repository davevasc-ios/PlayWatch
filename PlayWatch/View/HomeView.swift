//
//  HomeView.swift
//  PlayWatch
//
//  Created by David on 14/4/24.
//

import SwiftUI

struct HomeView: View {
    @Bindable var localeManager: LocaleManager
    @Environment(HomeViewModel.self) private var homeViewModel
    @State private var showSuggestions = true
    @State private var isSearching = false
    @State private var searchText: String = .empty
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack (alignment: .leading) {
                    if isSearching {
                        SearchView(items: homeViewModel.mediaSearchList)
                    } else {
                        MediaSectionView(sections: homeViewModel.mediaSectionsList)
                    }
                }
            }
            .refreshable {
                homeViewModel.action(.onRefresh)
            }
            .navigationTitle(Text(Tab.home.localized))
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            homeViewModel.action(.onAppear(localeManager.locale))
            //            viewModel.getGeminiResponse(prompt: "cuentame una hitoria vasca")
        }
        .searchable(text: $searchText, isPresented: $isSearching, placement: .automatic, prompt: Text(LocalizableString.homeSearchBar))
        .searchSuggestions {
            if showSuggestions {
                ForEach(homeViewModel.mediaSearchList) { item in
                    Button {
                        searchText = item.mediaName
                        showSuggestions = false
                    } label: {
                        Label(item.mediaName, systemImage: "bookmark")
                            .lineLimit(1)
                    }
                }
            }
        }
        .onChange(of: searchText) {
            if searchText.count > 0 {
                homeViewModel.action(.onChangeSearch(searchText))
            } else {
                homeViewModel.action(.onChangeTrending)
                showSuggestions = true
            }
        }
        .onChange(of: isSearching) {
            if isSearching {
                homeViewModel.action(.onChangeTrending)
            }
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
                Text("Release : ")
                if let date = item.mediaReleaseDate {
                    Text(date.toString())
                }
            }
            HStack {
                Text("Url: ")
                Text(item.mediaImage)
            }
            HStack {
                Text("Name: ")
                Text(item.mediaName)
            }
            HStack {
                Text("Original Name: ")
                Text(item.mediaOriginalName)
            }
            HStack {
                Text("Media Type: ")
                Text(item.media.rawValue)
            }
            HStack {
                Text("Overview: ")
                Text(item.overview.orEmpty)
            }
        }
    }
}

struct MediaPosterView: View {
    let item: Media
    
    var body: some View {
        CacheAsyncImage(url: MovieDB.getImageUrl(file: item.mediaImage, size: .medium)) { phase in
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
                    if item.media == .person {
                        PersonNameView(text: item.mediaName)
                    }
                }
            case .failure (let error):
                switch error {
                case let urlError as URLError where urlError.code == .cancelled:
                    MediaPosterView(item: item)
                default:
                    EmptyPosterView(text: item.mediaName)
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

#Preview {
    HomeView(localeManager: LocaleManager())
        .environment(HomeViewModel())
}
