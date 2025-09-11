//
//  SearchViewLG.swift
//  PlayWatch
//
//  Created by David on 12/9/25.
//

import SwiftUI

struct SearchViewLG: View {
    @Environment(AppViewModel.self) private var vm
    @State private var search: String = .empty
    @State private var showSuggestions = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach (vm.homeModelLogic.mediaSearchList) { item in
                        NavigationLink(destination: MediaDetailView(item: item)) {
                            SearchCellView(item: item)
                        }
                    }
                }
            }
        }
        .onAppear {
            vm.homeModelLogic.on(.changeTrending)
        }
        .searchable(text: $search, prompt: Text(LocalizableString.homeSearchBar))
//        .tabBarMinimizeBehavior(.onScrollDown)
        .searchSuggestions {
            if showSuggestions {
                ForEach(vm.homeModelLogic.mediaSearchList) { item in
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
                vm.homeModelLogic.on(.changeSearch(search))
            } else {
                vm.homeModelLogic.on(.changeTrending)
                showSuggestions = true
            }
        }
    }
}

#Preview {
    SearchViewLG()
        .environment(AppViewModel.preview)
}
