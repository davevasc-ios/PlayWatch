//
//  MediaDetailView.swift
//  PlayWatch
//
//  Created by David on 4/10/25.
//

import SwiftUI

struct MediaDetailView: View {
    let item: Media
    let namespace: Namespace.ID
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
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
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 600)
                            .clipped()
                            .stretchyHeader()
                    case .failure:
                        EmptyPosterView(text: item.name)
                    @unknown default:
                        EmptyView()
                    }
                }
                .navigationTransition(.zoom(sourceID: item.id, in: namespace))

                VStack(alignment: .leading, spacing: 15) {
                    Text(item.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(item.type.rawValue)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    if let date = item.date {
                        HStack {
                            Text("📅")
                            Text(date.toString(format: .display))
                                .font(.headline)
                        }
                    }
                    RatingBadgeView(rating: item.rating)
                }
                .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
        .interactiveDismissDisabled()
    }
}


struct RatingBadgeView: View {
    let rating: Double?

    var body: some View {
        if let rating = rating, rating > 0 {
            HStack(spacing: 8) {
                Text(rating.formatted(.number.precision(.fractionLength(1))))
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundStyle(badgeColor) // Texto del color del rating
                
                Rectangle()
                    .fill(badgeColor.opacity(0.3))
                    .frame(width: 1, height: 14)

                Text(starsString)
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(badgeColor.opacity(0.15)) // Fondo muy suave
            )
            .overlay(
                Capsule()
                    .strokeBorder(badgeColor.opacity(0.5), lineWidth: 1)
            )
        } else {
            Text("Sin valoración")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(8)
                .background(.ultraThinMaterial, in: Capsule())
        }
    }

    private var badgeColor: Color {
        guard let rating = rating else { return .secondary }
        return switch rating {
        case ..<5.0: .red
        case 5.0..<6.0: .orange
        case 6.0..<7.0: .blue
        default: .green
        }
    }

    private var starsString: String {
        guard let rating = rating else { return "" }
        let starCount = Int((rating / 2.0).rounded())
        let clampedCount = max(0, min(5, starCount))
        return String(repeating: "⭐️", count: clampedCount)
    }
}

#if DEBUG
#Preview {
    @Previewable @Namespace var previewNamespace
    NavigationStack {
        MediaDetailView(item: Media.test, namespace: previewNamespace)
    }
}
#endif
