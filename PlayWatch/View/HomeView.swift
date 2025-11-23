//
//  HomeView.swift
//  PlayWatch
//
//  Created by David on 14/4/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppService.self) private var appService
    @Namespace private var heroTransition
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack (alignment: .leading) {
                    switch appService.mediaService.homeState {
                    case .empty:
                        Text("No data")
                    case .loading:
                        ProgressView()
                    case .loaded(let mediaSectionList, _):
                        MediaSectionView(sections: mediaSectionList, namespace: heroTransition)
                    case .failure(let error):
                        Text(error.localizedDescription)
                    }
                }
            }
            .refreshable {
                appService.mediaService.on(.slideToRefresh)
            }
            .navigationTitle(Text(AppTab.home.localized))
            .toolbarTitleDisplayMode(.inlineLarge)
            .accountToolbar()
            .languageToolbar()
            .navigationDestination(for: Media.self) { media in
                MediaDetailView(item: media, namespace: heroTransition)
            }
        }
        .onAppear {
            appService.mediaService.on(.viewAppear)
        }
//        .id(appService.preferencesService.selectedLanguage)
    }
}


struct AccountToolbarModifier: ViewModifier {
    @State private var showingAccount = false
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAccount.toggle()
                    } label: {
                        Image(systemName: "person.fill")
                    }
                    .popover(isPresented: $showingAccount) {
                        AccountView()
                            .presentationDetents([.medium, .large])
                            .presentationCompactAdaptation(.sheet)
                    }
                }
                ToolbarSpacer(.fixed, placement: .topBarTrailing)
            }
    }
}

extension View {
    func accountToolbar() -> some View {
        modifier(AccountToolbarModifier())
    }
}


struct LanguageToolbarModifier: ViewModifier {
    @Environment(AppService.self) private var appService
    @State private var showingLanguage = false
    
    func body(content: Content) -> some View {
        @Bindable var preferences = appService.preferencesService

        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingLanguage.toggle()
                    } label: {
                        if let loadedLanguageCode = appService.mediaService.homeState.loadedLanguageCode {
                            Text(loadedLanguageCode)
                        } else {
                            ProgressView()
                        }
                    }
                    .popover(isPresented: $showingLanguage) {
                        LanguageGridPicker(
                            selectedLanguage: $preferences.selectedLanguage,
                            showingLanguage: $showingLanguage,
                            languages: AppLanguage.allCases
                        )
                        .presentationCompactAdaptation(.popover)
                    }
                }
                ToolbarSpacer(.fixed, placement: .topBarTrailing)
            }
    }
}

extension View {
    func languageToolbar() -> some View {
        modifier(LanguageToolbarModifier())
    }
}

struct LanguageGridPicker: View {
    @Environment(AppService.self) private var appService

    @Binding var selectedLanguage: AppLanguage
    @Binding var showingLanguage: Bool
    let languages: [AppLanguage]

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 3
    )
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Selecciona idioma")
                .font(.headline)
            
            ForEach(languages) { language in
                Button {
                    if selectedLanguage != language {
                        selectedLanguage = language
                        appService.mediaService.on(.viewAppear)
                    }
                    showingLanguage.toggle()
                } label: {
                    Text(language.nativeName)
                        .font(.subheadline)
                        .fontWeight(selectedLanguage == language ? .bold : .regular)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            selectedLanguage == language
                            ? Color.accentColor.opacity(0.4)
                            : Color.secondary.opacity(0.2),
                            in: ContainerRelativeShape()
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}

struct MediaSectionView: View {
    let sections: [MediaSection]
    let namespace: Namespace.ID
    
    var body: some View {
        ForEach (sections) { section in
            LazyVStack (spacing: 0) {
                MediaTitleView(title: section.title)
                MediaFlowView(items: section.items, namespace: namespace)
            }
        }
    }
}

struct MediaTitleView: View {
    let title: LocalizedStringResource
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
    }
}

struct MediaFlowView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    let items: [Media]
    let namespace: Namespace.ID
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 4) {
                ForEach(items) { item in
                    NavigationLink(value: item) {
                        MediaPosterView(item: item)
                            .containerRelativeFrame(.horizontal,
                                                    count: verticalSizeClass == .regular ? 3 : 8,
                                                    spacing: 4)
                        
                            .scrollTransition(topLeading: .interactive,
                                              bottomTrailing: .interactive,
                                              axis: .horizontal) { effect, phase in
                                effect
                                    .opacity(phase.isIdentity ? 1.0 : 0.2)
                                    .scaleEffect(x: phase.isIdentity ? 1.0 : 0.6,
                                                 y: phase.isIdentity ? 1.0 : 0.6)
                                    .offset(y: phase.isIdentity ? 0 : 50)
                                    .rotation3DEffect(.degrees(abs(phase.value - 0.1) * 40),
                                                      axis: (x: 0.2, y: 1, z: 0), anchor: .leading)
                            }
                                              .matchedTransitionSource(id: item.id, in: namespace)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(4, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
}

struct MediaPosterView: View {
    let item: Media
    
    var body: some View {
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
                ZStack (alignment: .bottom) {
                    image
                        .resizable()
                    if item.type == .person {
                        PersonNameView(text: item.name)
                    }
                }
            case .failure (let error):
                switch error {
                case let urlError as URLError where urlError.code == .cancelled:
                    MediaPosterView(item: item)
                default:
                    EmptyPosterView(text: item.name)
                }
            @unknown default:
                EmptyView()
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .cornerRadius(10)
        .shadow(radius: 4, y: 4)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 0))
    }
}

struct PersonNameView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title3)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
            .background(Color.random
                .gradient
                .opacity(0.5))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 8, trailing: 4))
    }
}

struct EmptyPosterView: View {
    let text: String
    
    var body: some View {
        ZStack (alignment: .bottom) {
            Rectangle()
                .foregroundStyle(Color.systemRandom.gradient)
                .opacity(0.5)
            TitleNameView(text: text)
        }
    }
}

struct TitleNameView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title2)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
            .background(Color.random
                .gradient
                .opacity(0.5))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 8, trailing: 4))
    }
}

#if DEBUG
#Preview {
    HomeView()
        .environment(AppService.preview)
}
#endif

