//
//  HomePageViewModel.swift
//  Marvel
//
//  Created by Vasilis Polyzos on 5/4/24.
//

import Foundation
import Combine

final class HomePageViewModel: ObservableObject {
    private (set) var list: [Character]? = []
    private (set) var squadList: [SquadModel] = []
    private (set) var showErrorView: Bool = false
    private var response: CharactersModel?
    private var manager = APIManager.shared
    private var dataFactory = DataFactory()
    let finishedLoading = PassthroughSubject<Bool, Never>()
    
    @MainActor
    func fetchList() async {
        do {
            self.response = try await manager.fetchCharactedListData()
            self.list = self.response?.data?.results
        } catch {
            showErrorView = true
        }
        finishedLoading.send(true)
    }
    
    func httpsConversion(url: String) -> String {
        return dataFactory.httpsConversion(url: url)
    }
    
    func loadSquadMembers() {
        self.squadList = dataFactory.loadSquadMembers()
    }
    
    func addSquadMember(character: Character) {
        self.squadList.append(dataFactory.characterToSquad(character: character))
        self.updateSquadList()
    }
    
    func removeSquadMember(character: Character) {
        self.squadList.removeAll(where: { char in
            character.name == char.name
        })
        self.updateSquadList()
    }
    
    func updateSquadList() {
        dataFactory.updateSquadList(list: self.squadList)
        self.finishedLoading.send(false)
    }
    
    func searchSquadMember(character: Character) -> Bool {
        return self.squadList.contains(where: { char in
            char.name == character.name
        })
    }
    
    func characterToSquad(character: Character) -> SquadModel {
        return SquadModel(from: character)
    }
}
