//
//  SectionDetailView.swift
//  PlayWatch
//
//  Created by David on 13/12/25.
//

import SwiftUI

struct SectionDetailView: View {
    let section: MediaSection
    let namespace: Namespace.ID
    
    private let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 10)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(section.items) { item in
                    NavigationLink(value: item) {
                        MediaCardView(card: item)
                            .matchedTransitionSource(id: item.id, in: namespace)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .contentMargins(16, for: .scrollContent)
        .navigationTitle(section.type.title)
        .navigationBarTitleDisplayMode(.inline)
        }
    
}

#if DEBUG
#Preview {
    @Previewable @Namespace var previewNamespace
    NavigationStack {
        SectionDetailView(section: .preview, namespace: previewNamespace)
    }
}
#endif
