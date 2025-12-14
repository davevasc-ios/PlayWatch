//
//  MediaCardView.swift
//  PlayWatch
//
//  Created by David on 13/12/24.
//

import SwiftUI

struct MediaCardView: View {
    let card: Media
    
    var body: some View {
        CacheAsyncImage(url: card.imageUrl) { phase in
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
                    if card.type == .person {
                        PersonNameView(text: card.name)
                    }
                }
            case .failure (let error):
                switch error {
                case let urlError as URLError where urlError.code == .cancelled:
                    MediaCardView(card: card)
                default:
                    EmptyPosterView(text: card.name)
                }
            @unknown default:
                EmptyView()
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .cornerRadius(10)
        .shadow(radius: 4, y: 4)
        .padding(.bottom)
    }
}

#if DEBUG
#Preview {
    MediaCardView(card: .preview)
}
#endif
