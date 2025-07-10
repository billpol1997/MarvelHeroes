//
//  CharacterPageViewModelTests.swift
//  MarvelTests
//
//  Created by Vasilis Polyzos on 6/7/25.
//

import XCTest
@testable import Marvel

final class CharacterPageViewModelTests: XCTestCase {
    // MARK: - Properties

    var character: Character!
    var addCalled: Bool!
    var removeCalled: Bool!
    var viewModel: CharacterPageViewModel!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        // Use a minimal Character from your model or decode from JSON if needed
        character = Character(id: 1, name: "Iron Man", description: "1234", thumbnail: CharacterImage(path: "http://123456"))
        addCalled = false
        removeCalled = false
        viewModel = CharacterPageViewModel(
            character: character,
            isInSquad: false,
            addSquadMember: { self.addCalled = true },
            removeSquadMember: { self.removeCalled = true }
        )
    }

    override func tearDown() {
        character = nil
        viewModel = nil
        addCalled = nil
        removeCalled = nil
        super.tearDown()
    }

    // MARK: - Initial State

    /// Tests that the view model initializes with correct properties
    func testInitialValues() {
        XCTAssertEqual(viewModel.character.name, "Iron Man")
        XCTAssertFalse(viewModel.isInSquad)
        XCTAssertNotNil(viewModel.addSquadMember)
        XCTAssertNotNil(viewModel.removeSquadMember)
    }

    // MARK: - Squad Logic

    /// Tests that addInSquad sets isInSquad to true and calls addSquadMember closure
    func testAddInSquad() {
        viewModel.changeSquadList() // Should add since isInSquad is false
        XCTAssertTrue(viewModel.isInSquad)
        XCTAssertTrue(addCalled)
        XCTAssertFalse(removeCalled)
    }

    /// Tests that kickOutFromSquad sets isInSquad to false and calls removeSquadMember closure
    func testKickOutFromSquad() {
        // First add, then remove
        viewModel.changeSquadList() // Add
        addCalled = false // Reset for next action
        viewModel.changeSquadList() // Remove
        XCTAssertFalse(viewModel.isInSquad)
        XCTAssertTrue(removeCalled)
        XCTAssertFalse(addCalled)
    }

    /// Tests that changeSquadList toggles isInSquad and calls correct closure
    func testChangeSquadListToggles() {
        // Add
        viewModel.changeSquadList()
        XCTAssertTrue(viewModel.isInSquad)
        XCTAssertTrue(addCalled)
        // Remove
        addCalled = false
        removeCalled = false
        viewModel.changeSquadList()
        XCTAssertFalse(viewModel.isInSquad)
        XCTAssertTrue(removeCalled)
    }

    // MARK: - URL Conversion

    /// Tests that httpsConversion correctly converts http URLs
    func testHttpsConversionWithHttpUrl() {
        let url = "http://example.com/image.jpg"
        let httpsUrl = viewModel.httpsConversion(url: url)
        XCTAssertEqual(httpsUrl, "https://example.com/image.jpg")
    }

    /// Tests that httpsConversion leaves https URLs unchanged
    func testHttpsConversionWithHttpsUrl() {
        let url = "https://secure.com/image.png"
        let httpsUrl = viewModel.httpsConversion(url: url)
        XCTAssertEqual(httpsUrl, url)
    }
}
