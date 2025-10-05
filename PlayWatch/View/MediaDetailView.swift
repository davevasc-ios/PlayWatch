//
//  MediaDetailView.swift
//  PlayWatch
//
//  Created by David on 4/10/25.
//

import SwiftUI

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

#if DEBUG
#Preview {
//    MediaDetailView(media: )
}
#endif
