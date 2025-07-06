//
//  HomePageView.swift
//  Marvel
//
//  Created by Vasilis Polyzos on 6/7/25.
//

import SwiftUI

struct HomePageView: View {
    @StateObject var viewModel: HomePageViewModel
    @State private var navigateToCharacterPage: Bool = false
    @State private var characterPage: CharacterPageView?
    @State private var collapsedSquad: Bool = false
    @State private var scrollPosition: CGPoint = .zero
    
    //MARK: Init
    init(viewModel: HomePageViewModel) {
        self._viewModel = StateObject(wrappedValue: DIContainer.shared.getContainerSwinject().resolve(HomePageViewModel.self)!)
    }

    // MARK: - Body
    var body: some View {
        content
            .navigationBarBackButtonHidden()
            .onAppear {
                Task {
                    await viewModel.fetchList(reset: true)
                }
                viewModel.loadSquadMembers()
            }
        NavigationLink(
            destination: characterPage,
            isActive: $navigateToCharacterPage,
            label: { EmptyView() }
        ).hidden()
    }

    // MARK: - Content View
    var content: some View {
        VStack {
            header
                .padding(.bottom, 6)
            divider
            squadList
            mainContent
        }
        .background(Color.greyDark)
    }

    // MARK: - Header
    var header: some View {
        HStack {
            Spacer()
            Image("marvelLogo")
                .resizable()
                .frame(width: 80, height: 32)
            Spacer()
        }
    }

    // MARK: - Divider
    var divider: some View {
        Rectangle()
            .background(.white.opacity(0.1))
            .frame(height: 1)
    }

    // MARK: - Main Content
    @ViewBuilder
    var mainContent: some View {
        if viewModel.showErrorView.not() == false {
            errorView
        } else if viewModel.list.isEmpty.not() == false && viewModel.isLoadingPage {
            ProgressView()
        } else {
            characterList
        }
    }

    // MARK: - Character List with Pagination
    @ViewBuilder
    var characterList: some View {
        ScrollView {
            LazyVStack {
                ForEach(Array(viewModel.list.enumerated()), id: \.element.id) { index, character in
                    HeroView(
                        image: viewModel.httpsConversion(url: character.thumbnail?.path ?? ""),
                        name: character.name ?? "Unknown"
                    )
                    .onTapGesture {
                        let characterViewModel = CharacterPageViewModel(
                            character: character,
                            isInSquad: viewModel.searchSquadMember(character: character),
                            addSquadMember: { viewModel.addSquadMember(character: character) },
                            removeSquadMember: { viewModel.removeSquadMember(character: character) }
                        )
                        self.characterPage = CharacterPageView(viewModel: characterViewModel)
                        self.navigateToCharacterPage = true
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .onAppear {
                        // Infinite scroll trigger when 5 from the end
                        if index >= viewModel.list.count - 5 &&
                            viewModel.canLoadMorePages &&
                            viewModel.isLoadingPage.not() {
                            Task {
                                await viewModel.fetchList()
                            }
                        }
                    }
                }
                if viewModel.isLoadingPage {
                    ProgressView()
                        .padding()
                }
            }
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: geometry.frame(in: .named("scroll")).origin
                    )
            })
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                withAnimation(.spring(.bouncy, blendDuration: 0.3)) {
                    if value.y < self.scrollPosition.y {
                        self.collapsedSquad = true
                    } else if value.y > self.scrollPosition.y {
                        self.collapsedSquad = false
                    } else {
                        self.scrollPosition = .zero
                    }
                }
            }
        }
        .coordinateSpace(name: "scroll")
        .refreshable {
            Task {
                await viewModel.fetchList(reset: true)
            }
        }
    }


    // MARK: - Squad List
    @ViewBuilder
    var squadList: some View {
        if viewModel.squadList.isEmpty.not() &&
            viewModel.showErrorView.not() &&
            collapsedSquad.not() {
            VStack(alignment: .leading) {
                Text("My Squad")
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.leading, 16)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.squadList, id: \.id) { character in
                            SquadView(
                                image: viewModel.httpsConversion(url: character.image),
                                name: character.name
                            )
                            .onTapGesture {
                                let char = Character(
                                    id: character.id,
                                    name: character.name,
                                    description: character.description,
                                    thumbnail: CharacterImage(path: character.image)
                                )
                                let characterViewModel = CharacterPageViewModel(
                                    character: char,
                                    isInSquad: viewModel.searchSquadMember(character: char),
                                    addSquadMember: { viewModel.addSquadMember(character: char) },
                                    removeSquadMember: { viewModel.removeSquadMember(character: char) }
                                )
                                
                                self.navigateToCharacterPage = true
                            }
                        }
                    }
                    .padding(.leading, 16)
                }
            }
        }
    }

    // MARK: - Error View
    var errorView: some View {
        Text("Oops! Something went wrong!")
            .bold()
            .foregroundColor(.white)
    }
}

// MARK: - ScrollOffsetPreferenceKey

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
