//
//  HomePageViewModel.swift
//  Marvel
//
//  Created by Vasilis Polyzos on 6/7/25.
//

import Foundation
import Combine

final class HomePageViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var list: [Character] = []
    @Published private(set) var squadList: [SquadModel] = []
    @Published var showErrorView: Bool = false
    @Published var isLoadingPage: Bool = false
    @Published var total: Int = 0

    // MARK: - Private Properties
    private var currentOffset: Int = 0
    private let pageSize: Int = 100 // Marvel API max is 100
    private var manager = APIManager.shared
    private var dataFactory = DataFactory()

    // MARK: - Computed Properties
    var canLoadMorePages: Bool {
        list.isEmpty || (list.count < total && isLoadingPage.not())
    }

    // MARK: - Pagination Fetch
    @MainActor
    func fetchList(reset: Bool = false) async {
        guard canLoadMorePages else { return }
        isLoadingPage = true

        if reset {
            currentOffset = 0
        }

        do {
            let response = try await manager.fetchCharactedListData(limit: pageSize, offset: currentOffset)
            let newCharacters = response.data?.results ?? []
            self.total = response.data?.total ?? 0

            if reset {
                self.list = newCharacters
            } else {
                self.list.append(contentsOf: newCharacters)
            }

            currentOffset += newCharacters.count
            showErrorView = false
        } catch {
            showErrorView = true
        }

        isLoadingPage = false
    }

    // MARK: - Squad Methods
    func httpsConversion(url: String) -> String {
        dataFactory.httpsConversion(url: url)
    }

    func loadSquadMembers() {
        self.squadList = dataFactory.loadSquadMembers()
    }

    func addSquadMember(character: Character) {
        self.squadList.append(dataFactory.characterToSquad(character: character))
        self.updateSquadList()
    }

    func removeSquadMember(character: Character) {
        self.squadList.removeAll { $0.name == character.name }
        self.updateSquadList()
    }

    func updateSquadList() {
        dataFactory.updateSquadList(list: self.squadList)
    }

    func searchSquadMember(character: Character) -> Bool {
        self.squadList.contains { $0.name == character.name }
    }
}
