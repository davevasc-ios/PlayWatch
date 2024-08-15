//
//  SearchView.swift
//  PlayWatch
//
//  Created by David on 22/4/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    let items: [Media]
    var body: some View {
        ForEach (items) { item in
            NavigationLink(destination: MediaDetailView(item: item)) {
                SearchCellView(item: item)
            }
        }
    }
}


struct SearchCellView: View {
    let item: Media
    var body: some View {
        HStack (spacing: 20) {
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
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 20)))
            .frame(width: 40, height: 60)
            
            VStack (alignment: .leading) {
                Text(item.mediaName)
                HStack {
                    Text(item.mediaType ?? "")
                    Text(item.mediaReleaseDate?.toString() ?? "")
                }
            }
        }
        .padding()
    }
}

#Preview {
    HomeView(appManager: AppManager())
}
