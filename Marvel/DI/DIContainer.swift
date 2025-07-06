//
//  DIContainer.swift
//  Marvel
//
//  Created by Bill on 6/7/25.
//

import Foundation
import Swinject

public protocol SwinjectInterface{
    func getContainerSwinject() -> Container
}

final class DIContainer: SwinjectInterface {
    static let shared = DIContainer()
    
    var diContainer: Container {
        let container = Container()
        container.register(SplashScreenView.self) { _ in
            SplashScreenView()
        }
        container.register(HomePageView.self) { r in
            HomePageView(viewModel: r.resolve(HomePageViewModel.self)!)
        }
        
        container.register(HomePageViewModel.self) { _ in
            HomePageViewModel()
        }
        return container
    }
   
    func getContainerSwinject() -> Container {
        return diContainer
    }
    
}
