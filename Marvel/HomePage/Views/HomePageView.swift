//
//  HomePageView.swift
//  Marvel
//
//  Created by Vasilis Polyzos on 5/4/24.
//

import SwiftUI

struct HomePageView: View {
    @ObservedObject var viewModel: HomePageViewModel
    @State private var showList: Bool = false
    @State private var navigateToCharacterPage: Bool = false
    @State private var characterPage: CharacterPageView?
    @State private var collapsedSquad: Bool = false
    @State private var scrollPosition: CGPoint = .zero
    
    var body: some View {
        content
            .navigationBarBackButtonHidden()
            .onAppear {
                Task {
                    await viewModel.fetchList()
                }
                viewModel.loadSquadMembers()
            }
            .onReceive(viewModel.finishedLoading) { status in
                showList = status
                if !status {
                    viewModel.loadSquadMembers()
                }
            }
        NavigationLink(destination: characterPage,
                       isActive: self.$navigateToCharacterPage,
                       label: { EmptyView() } ).hidden()
    }
    
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
    
    var header: some View {
        HStack {
            Spacer()
            Image("marvelLogo")
                .resizable()
                .frame(width: 80, height: 32)
            Spacer()
        }
    }
    
    var divider: some View {
        Rectangle()
            .background(.white.opacity(0.1))
            .frame(height: 1)
    }
    
    @ViewBuilder
    var mainContent: some View {
        if showList {
            characterList
        } else {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    @ViewBuilder
    var characterList: some View {
        ScrollView {
            if let list = viewModel.list, !list.isEmpty, !viewModel.showErrorView {
                VStack {
                    ForEach(list, id: \.id) { character in
                        HeroView(image: viewModel.httpsConversion(url: character.thumbnail?.path ?? ""), name: character.name ?? "Unknown")
                            .onTapGesture {
                                let characterViewModel = CharacterPageViewModel(character: character, isInSquad: viewModel.searchSquadMember(character: character), addSquadMember: { viewModel.addSquadMember(character: character) }, removeSquadMember: { viewModel.removeSquadMember(character: character) })
                                self.characterPage = CharacterPageView(viewModel: characterViewModel)
                                self.navigateToCharacterPage = true
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                    }
                }
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    withAnimation(.spring(.bouncy,blendDuration: 0.3)) {
                        if value.y < self.scrollPosition.y {
                            self.collapsedSquad = true
                        } else if value.y > self.scrollPosition.y {
                            self.collapsedSquad = false
                        } else {
                            self.scrollPosition = .zero
                        }
                    }
                }
            } else {
                errorView
            }
        }
    }
    
    @ViewBuilder
    var squadList: some View {
        if !viewModel.squadList.isEmpty, !viewModel.showErrorView, !self.collapsedSquad {
            VStack(alignment: .leading) {
                Text("My Squad")
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.leading, 16)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.squadList, id: \.id) { character in
                            SquadView(image: viewModel.httpsConversion(url: character.image), name: character.name)
                                .onTapGesture {
                                    let char = Character(id: character.id, name: character.name, description: character.description, thumbnail: CharacterImage(path: character.image))
                                    let characterViewModel = CharacterPageViewModel(character: char, isInSquad: viewModel.searchSquadMember(character: char), addSquadMember: { viewModel.addSquadMember(character: char) }, removeSquadMember: { viewModel.removeSquadMember(character: char) })
                                    self.characterPage = CharacterPageView(viewModel: characterViewModel)
                                    self.navigateToCharacterPage = true
                                }
                            
                        }
                    }
                    .padding(.leading, 16)
                }
            }
            
        }
    }
    
    var errorView: some View {
        Text("Oops! Something went wrong!")
            .bold()
            .foregroundColor(.white)
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}
