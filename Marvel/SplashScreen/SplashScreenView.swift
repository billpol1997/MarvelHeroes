//
//  SplashScreenView.swift
//  Marvel
//
//  Created by Vasilis Polyzos on 11/4/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var navigateToHomePage: Bool = false
    @State private var homePage: HomePageView?
   
    var body: some View {
        content
            .background(Color.black)
        NavigationLink(destination: homePage,
                       isActive: self.$navigateToHomePage,
                       label: { EmptyView() } ).hidden()
    }
    
    var content: some View {
        VStack {
            Spacer()
            GifViewer(gif: "marvel-marvel-studios")
                .frame(height: 206, alignment: .center)
            Spacer()
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
                let homeViewModel = HomePageViewModel()
                self.homePage = HomePageView(viewModel: homeViewModel)
                self.navigateToHomePage = true
            }
        }
    }
}

