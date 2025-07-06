//
//  CharacterPageView.swift
//  Marvel
//
//  Created by Vasilis Polyzos on 6/7/25.
//

import SwiftUI
import Kingfisher

struct CharacterPageView: View {
    @ObservedObject var viewModel: CharacterPageViewModel
    @State var kickFromSquadTapped: Bool = false
    var size: CharacterImageSize = .big
    
    var body: some View {
        VStack {
            headerImage
            content
        }
        .background(Color.greyDark)
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonTitleHidden()
        .alert("Are you sure you want to kick " + (viewModel.character.name ?? "") + " out from Squad?", isPresented: $kickFromSquadTapped) {
            Button("No", role: .cancel) { }
            Button("Yes", role: .destructive) { viewModel.changeSquadList() }
            }
    }
    
    var content: some View {
        VStack( spacing: 16) {
            name
            squadButton
            description
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }
    
    var headerImage: some View {
        VStack {
            KFImage(URL(string: viewModel.httpsConversion(url: viewModel.character.thumbnail?.path ?? "" ) + size.rawValue))
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: 375)
            Spacer()
        }
        
    }
    
    var name: some View {
        HStack {
            Text(viewModel.character.name ?? "")
                .foregroundColor(.white)
                .bold()
                .font(.largeTitle)
            Spacer()
        }
    }
    
    var squadButton: some View {
        SquadButton(isInSquad: $viewModel.isInSquad) {
            if viewModel.isInSquad {
                kickFromSquadTapped = true
            } else {
                viewModel.changeSquadList()
            }
        }
    }
    
    var description: some View {
        HStack {
            VStack {
                Text(viewModel.character.description ?? "Not found")
                    .foregroundColor(.white)
                    .bold()
                    .font(.body)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            Spacer()
        }
    }
}


