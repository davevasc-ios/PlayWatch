//
//  HomeView.swift
//  PlayWatch
//
//  Created by David on 14/4/24.
//

import SwiftUI

// Extensión para limpiar la vista principal
extension View {
    func withAppDestinations(namespace: Namespace.ID) -> some View {
        self
            .navigationDestination(for: Media.self) { media in
                MediaDetailView(item: media, namespace: namespace)
            }
            .navigationDestination(for: MediaSection.self) { section in
                SectionDetailView(section: section, namespace: namespace)
            }
            .navigationDestination(for: AppTab.self) { tab in
                // Navegación programática a tabs, etc.
            }
    }
}


struct HomeView: View {
    @Environment(AppService.self) private var appService
    @Namespace private var heroTransition
    
    var body: some View {
        // TODO: - Resolver lo del onScrollDown
//        NavigationStack {
            ScrollView {
                LazyVStack (alignment: .leading) {
                    switch appService.mediaService.homeState {
                    case .idle, .loading:
                        ProgressView()
                    case .success(let homeContent):
                        if homeContent.isEmpty {
                            EmptyView()
                        } else {
                            MediaSectionView(sections: homeContent.sections, namespace: heroTransition)
                        }
                    case .failure(let error):
                        Text(error.localizedDescription)
                    }
                }
            }
            .refreshable {
                await appService.mediaService.on(.slideToRefresh)
            }
            .task(id: appService.preferencesService.selectedLanguage) {
                await appService.mediaService.on(.loadData)
            }
            .navigationTitle(Text(AppTab.home.localized))
            .toolbarTitleDisplayMode(.inlineLarge)
            .accountToolbar()
            .languageToolbar()
            .withAppDestinations(namespace: heroTransition)
//        }
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
                        if let value = appService.mediaService.homeState.value {
                            Text(value.locale.code.uppercased())
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(languages) { language in
                Button {
                    if selectedLanguage != language {
                        selectedLanguage = language
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
                NavigationLink(value: section) {
                    MediaTitleView(title: section.type.title)
                }
                MediaFlowView(section: section, namespace: namespace)
            }
        }
    }
}

struct MediaTitleView: View {
    let title: LocalizedStringResource
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Image(systemName: "chevron.right")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.bottom)
        .contentShape(Rectangle())
    }
}

struct MediaFlowView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    let section: MediaSection
    let namespace: Namespace.ID
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(section.items) { item in
                    NavigationLink(value: item) {
                        sectionContentView(for: item)
                            .matchedTransitionSource(id: item.id, in: namespace)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(.horizontal, 16, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
    
    
    @ViewBuilder
    private func sectionContentView(for item: Media) -> some View {
        switch section.type {
        case .hero:
            BackdropCardView(card: item)
                .containerRelativeFrame(
                    .horizontal,
                    count: verticalSizeClass == .regular ? 1 : 3,
                    spacing: 10
                )
                .scrollTransition(axis: .horizontal) { content, phase in
                    content
                        .scaleEffect(x: phase.isIdentity ? 1 : 0.8, y: phase.isIdentity ? 1 : 0.6)
                        .blur(radius: phase.isIdentity ? 0 : 2)
                        .opacity(phase.isIdentity ? 1 : 0.5)
                }
            
        default:
            MediaCardView(card: item)
                .containerRelativeFrame(
                    .horizontal,
                    count: verticalSizeClass == .regular ? 3 : 8,
                    spacing: 10
                )
                .scrollTransition(topLeading: .interactive, bottomTrailing: .interactive, axis: .horizontal) { content, phase in
                    content
                        .scaleEffect(x: phase.isIdentity ? 1 : 0.6, y: phase.isIdentity ? 1 : 0.4)
                        .blur(radius: phase.isIdentity ? 0 : 5)
                        .opacity(phase.isIdentity ? 1 : 0.2)
                }
        }
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

