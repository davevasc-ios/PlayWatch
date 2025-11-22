//
//  SearchView.swift
//  PlayWatch
//
//  Created by David on 12/9/25.
//

import SwiftUI

struct SearchView: View {
    @Environment(AppService.self) private var appService
    @State private var search: String = .empty
    @State private var showSuggestions = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach (appService.mediaService.mediaSearchList) { item in
                        NavigationLink(destination: MediaDetailView(item: item)) {
                            SearchCellView(item: item)
                        }
                    }
                }
            }
            .navigationTitle(Text(AppTab.search.localized))
            .toolbarTitleDisplayMode(.inlineLarge)
            .accountToolbar()
        }
        .onAppear {
            appService.mediaService.on(.changeTrending)
        }
        .searchable(text: $search, prompt: Text(Localizable.Search.searchBar))

        .searchSuggestions {
            if showSuggestions {
                ForEach(appService.mediaService.mediaSearchList) { item in
                    Button {
                        search = item.name
                        showSuggestions = false
                    } label: {
                        Label(item.name, systemImage: "bookmark")
                            .lineLimit(1)
                    }
                }
            }
        }
        .onChange(of: search) {
            if search.count > 0 {
                appService.mediaService.on(.changeSearch(search))
            } else {
                appService.mediaService.on(.changeTrending)
                showSuggestions = true
            }
        }
    }
}

struct SearchCellView: View {
    let item: Media
    var body: some View {
        HStack (spacing: 20) {
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
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 20)))
            .frame(width: 40, height: 60)
            
            VStack (alignment: .leading) {
                Text(item.name)
                HStack {
                    Text(item.type.rawValue)
                    Text(item.date?.toString(format: .display) ?? "")
                }
            }
        }
        .padding()
    }
}

#if DEBUG
#Preview {
    SearchView()
        .environment(AppService.preview)
}
#endif
