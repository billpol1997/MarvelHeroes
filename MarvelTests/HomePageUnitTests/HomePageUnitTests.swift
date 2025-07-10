//
//  HomePageUnitTests.swift
//  MarvelTests
//
//  Created by Vasilis Polyzos on 6/7/25.
//

import XCTest
@testable import Marvel

struct MarvelCharactersWrapper: Decodable {
    let data: DataBlock
}

struct DataBlock: Decodable {
    let results: [Character]
}

final class HomePageViewModel_CharactersJSON_Tests: XCTestCase {
    var viewModel: HomePageViewModel!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        viewModel = HomePageViewModel()
        UserDefaults.standard.removeObject(forKey: "Squad")
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Helpers

    /// Loads the characters array from the bundled characters.json file
    func loadCharactersFromJSON() -> [Character] {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "characters", withExtension: "json") else {
            XCTFail("Missing characters.json file in test bundle")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let wrapper = try JSONDecoder().decode(MarvelCharactersWrapper.self, from: data)
            return wrapper.data.results
        } catch {
            XCTFail("Failed to decode characters.json: \(error)")
            return []
        }
    }

    // MARK: - Squad List Logic

    /// Tests adding all characters from JSON to the squad list
    func testAddAllCharactersToSquad() {
        let characters = loadCharactersFromJSON()
        XCTAssertFalse(characters.isEmpty)
        for character in characters {
            viewModel.addSquadMember(character: character)
        }
        XCTAssertEqual(viewModel.squadList.count, characters.count)
        for character in characters {
            XCTAssertTrue(viewModel.squadList.contains { $0.name == character.name })
        }
    }

    /// Tests removing a character from the squad list
    func testRemoveCharacterFromSquad() {
        let characters = loadCharactersFromJSON()
        guard let first = characters.first else { XCTFail("No characters in JSON"); return }
        viewModel.addSquadMember(character: first)
        XCTAssertTrue(viewModel.squadList.contains { $0.name == first.name })
        viewModel.removeSquadMember(character: first)
        XCTAssertFalse(viewModel.squadList.contains { $0.name == first.name })
    }

    /// Tests that duplicate squad members can be added (current behavior)
    func testAddDuplicateSquadMembers() {
        let characters = loadCharactersFromJSON()
        guard let first = characters.first else { XCTFail("No characters in JSON"); return }
        viewModel.addSquadMember(character: first)
        viewModel.addSquadMember(character: first)
        XCTAssertEqual(viewModel.squadList.count, 2)
    }

    /// Tests removing a character not in the squad does not crash or affect squad
    func testRemoveNonExistentSquadMember() {
        let characters = loadCharactersFromJSON()
        guard let first = characters.first else { XCTFail("No characters in JSON"); return }
        viewModel.removeSquadMember(character: first)
        XCTAssertTrue(viewModel.squadList.isEmpty)
    }

    /// Tests searching for a squad member returns correct boolean
    func testSearchSquadMember() {
        let characters = loadCharactersFromJSON()
        guard let first = characters.first else { XCTFail("No characters in JSON"); return }
        XCTAssertFalse(viewModel.searchSquadMember(character: first))
        viewModel.addSquadMember(character: first)
        XCTAssertTrue(viewModel.searchSquadMember(character: first))
    }

    // MARK: - Persistence

    /// Tests saving and loading squad list to/from UserDefaults
    func testSquadPersistenceWithJSONCharacters() {
        let characters = loadCharactersFromJSON()
        for character in characters {
            viewModel.addSquadMember(character: character)
        }
        viewModel.updateSquadList()
        viewModel.setSquadList(list: [])
        viewModel.loadSquadMembers()
        XCTAssertEqual(viewModel.squadList.count, characters.count)
    }

    /// Tests loading squad members from corrupt UserDefaults data gracefully
    func testLoadSquadMembersWithCorruptData() {
        UserDefaults.standard.setValue(Data([0x01, 0x02, 0x03]), forKey: "Squad")
        viewModel.loadSquadMembers()
        XCTAssertTrue(viewModel.squadList.isEmpty)
    }

    /// Tests updating squad list with an empty list persists correctly
    func testUpdateSquadListWithEmptyList() {
        viewModel.setSquadList(list: [])
        viewModel.updateSquadList()
        let data = UserDefaults.standard.data(forKey: "Squad")
        XCTAssertNotNil(data)
        let loaded = try! JSONDecoder().decode([SquadModel].self, from: data!)
        XCTAssertTrue(loaded.isEmpty)
    }

    // MARK: - URL Conversion

    /// Tests that http URLs are correctly converted to https
    func testHttpsConversionWithHttpUrl() {
        let url = "http://example.com/image.jpg"
        let httpsUrl = viewModel.httpsConversion(url: url)
        XCTAssertEqual(httpsUrl, "https://example.com/image.jpg")
    }

    /// Tests that https URLs remain unchanged
    func testHttpsConversionWithHttpsUrl() {
        let url = "https://secure.com/image.png"
        let httpsUrl = viewModel.httpsConversion(url: url)
        XCTAssertEqual(httpsUrl, url)
    }

    // MARK: - Initial State

    /// Tests initial published properties are set correctly
    func testInitialValues() {
        XCTAssertTrue(viewModel.list.isEmpty)
        XCTAssertTrue(viewModel.squadList.isEmpty)
        XCTAssertFalse(viewModel.showErrorView)
        XCTAssertFalse(viewModel.isLoadingPage)
        XCTAssertEqual(viewModel.total, 0)
    }

    // MARK: - Pagination Logic

    /// Tests canLoadMorePages returns true when list is empty
    func testCanLoadMorePagesWhenListIsEmpty() {
        XCTAssertTrue(viewModel.canLoadMorePages)
    }

    /// Tests canLoadMorePages returns false when list count equals total
    func testCanLoadMorePagesWhenListIsFull() {
        let characters = loadCharactersFromJSON()
        viewModel.setList(list: Array(characters.prefix(2)))
        viewModel.total = 2
        viewModel.isLoadingPage = false
        XCTAssertFalse(viewModel.canLoadMorePages)
    }

    /// Tests canLoadMorePages returns true when list count is less than total
    func testCanLoadMorePagesWhenListIsNotFull() {
        let characters = loadCharactersFromJSON()
        viewModel.setList(list: Array(characters.prefix(1)))
        viewModel.total = 2
        viewModel.isLoadingPage = false
        XCTAssertTrue(viewModel.canLoadMorePages)
    }

    /// Tests setting squad list directly works as expected
    func testSetSquadListDirectly() {
        let characters = loadCharactersFromJSON()
        let squadModels = characters.map { SquadModel(from: $0) }
        viewModel.setSquadList(list: squadModels)
        XCTAssertEqual(viewModel.squadList.count, squadModels.count)
    }
}
