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
    
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if let url = url, case .success(let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}

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

#if DEBUG
#Preview {
    CacheAsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/6tJWxRfBKWGIPFkfLTod2CgCexU.jpg")) { phase in
        switch phase {
        case .empty: ProgressView()
        case .success (let image): image
        case .failure: EmptyView()
        @unknown default: EmptyView()
        }
    }
}
#endif
