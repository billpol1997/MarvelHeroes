//
//  MarvelApp.swift
//  Marvel
//
//  Created by Vasilis Polyzos on 6/7/25.
//

import SwiftUI

@main
struct MarvelApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                DIContainer.shared.getContainerSwinject().resolve(SplashScreenView.self)!
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
