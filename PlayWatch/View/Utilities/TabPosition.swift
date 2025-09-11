////
////  TabPosition.swift
////  PlayWatch
////
////  Created by David on 15/4/24.
////
//
//import SwiftUI
//
//struct PositionKey: PreferenceKey {
//    static let defaultValue: CGRect = .zero
//    
//    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
//        value = nextValue()
//    }
//    
//}
//
//extension View {
//    @ViewBuilder
//    func viewPosition(completion: @escaping (CGRect) -> ()) -> some View {
//        self
//            .overlay {
//                GeometryReader { geometry in
//                    let rect = geometry.frame(in: .global)
//                    Color.clear
//                        .preference(key: PositionKey.self, value: rect)
//                        .onPreferenceChange (PositionKey.self, perform: completion)
//                }
//            }
//    }
//}
