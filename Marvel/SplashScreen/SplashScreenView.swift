//
//  SplashScreenView.swift
//  Marvel
//
//  Created by Vasilis Polyzos on 6/7/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var navigateToHomePage: Bool = false
   
    var body: some View {
        content
            .background(Color.black)
        NavigationLink(destination: DIContainer.shared.getContainerSwinject().resolve(HomePageView.self)!,
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
                self.navigateToHomePage = true
            }
        }
    }
}

