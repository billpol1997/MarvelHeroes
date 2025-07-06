//
//  CharacterPageViewModel.swift
//  Marvel
//
//  Created by Vasilis Polyzos on 6/7/25.
//

import Foundation

final class CharacterPageViewModel: ObservableObject {
   @Published var isInSquad: Bool
    private(set) var character: Character
    private let defaults = UserDefaults.standard
    private var dataFactory = DataFactory()
    let addSquadMember: () -> ()
    let removeSquadMember: () -> ()
    
    init(character: Character, isInSquad: Bool, addSquadMember: @escaping () -> Void, removeSquadMember: @escaping () -> Void) {
        self.character = character
        self.isInSquad = isInSquad
        self.addSquadMember = addSquadMember
        self.removeSquadMember = removeSquadMember
    }
    
     private func addInSquad() {
        self.addSquadMember()
        self.isInSquad = true
    }
    
    private func kickOutFromSquad() {
        self.removeSquadMember()
        self.isInSquad = false
    }
    
    func changeSquadList() {
        isInSquad.not() ? addInSquad() : kickOutFromSquad()
    }
    
    func httpsConversion(url: String) -> String {
        return dataFactory.httpsConversion(url: url)
    }
}

