//
//  BackdropCardView.swift
//  PlayWatch
//
//  Created by David on 7/12/25.
//

import SwiftUI

struct BackdropCardView: View {
    let card: Media
    
    var body: some View {
        CacheAsyncImage(url: card.backdropUrl) { phase in
            switch phase {
            case .empty:
                loadingView
            case .success(let image):
                successView(image: image)
            case .failure(let error):
                failureView(error: error)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    // MARK: - Loading State
    private var loadingView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
            
            ProgressView()
                .controlSize(.large)
                .tint(.purple)
        }
        .frame(height: 220)
        .padding(.horizontal)
    }
    
    // MARK: - Success State
    @ViewBuilder
    private func successView(image: Image) -> some View {
        ZStack(alignment: .bottom) {
            image
                .resizable()
                .aspectRatio(16/9, contentMode: .fit)
            
            LinearGradient(
                colors: [
                    .clear,
                    .black.opacity(0.3),
                    .black.opacity(0.8)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .aspectRatio(16/9, contentMode: .fit)
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text(card.name)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 12) {
                    if let rating = card.rating {
                        RatingView(rating: rating)
                    }
                    
                    if let date = card.date {
                        Text(date.formatted(.dateTime.year()))
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    TypeBadge(type: card.type)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 4, y: 4)
        .padding(.bottom)
    }
    
    // MARK: - Failure State
    @ViewBuilder
    private func failureView(error: Error) -> some View {
        switch error {
        case let urlError as URLError where urlError.code == .cancelled:
            BackdropCardView(card: card)
        default:
            EmptyPosterView(text: card.name)
        }
    }
}

// MARK: - Rating View Component
struct RatingView: View {
    let rating: Double
    private let maxRating: Double = 10.0
    
    var normalizedRating: Double {
        (rating / maxRating) * 5
    }
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                Image(systemName: starType(for: index))
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
            
            Text(String(format: "%.1f", rating))
                .font(.caption.bold())
                .foregroundStyle(.white)
            
        }
    }
    
    private func starType(for index: Int) -> String {
        let fillAmount = normalizedRating - Double(index)
        
        if fillAmount >= 1.0 {
            return "star.fill"
        } else if fillAmount >= 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}

// MARK: - Type Badge Component
struct TypeBadge: View {
    let type: MovieDBType
    
    var body: some View {
        Text(type == .movie ? "PELÍCULA" : "SERIE")
            .font(.caption2.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial, in: Capsule())
    }
}


#if DEBUG
#Preview ("Success") {
    BackdropCardView(card: .preview)
}
#Preview ("Image Error") {
    BackdropCardView(card: .previewImageError)
}
#endif
