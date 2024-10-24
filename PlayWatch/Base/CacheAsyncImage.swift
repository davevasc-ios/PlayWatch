//
//  CacheAsyncImage.swift
//  PlayWatch
//
//  Created by David on 19/4/24.
//

import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View {
    private var url: URL?
    private var content: (AsyncImagePhase) -> Content
        
    init(url: URL?, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.content = content
    }
    
    var body: some View {
        if let url = url, let cached = ImageCache[url] {
            content(.success(cached))
        } else{
            AsyncImage(url: url, transaction: .init(animation: .bouncy)) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    
    @MainActor
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if let url = url, case .success(let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}

@MainActor
fileprivate class ImageCache {
    static var cache: [URL : Image] = [:]
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}

#Preview {
    CacheAsyncImage(url: URL(string: MockData.movie.image)!) { phase in
        switch phase {
        case .empty: ProgressView()
        case .success (let image): image
        case .failure: EmptyView()
        @unknown default: EmptyView()
        }
    }
}
