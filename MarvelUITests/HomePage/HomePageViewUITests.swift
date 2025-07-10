//
//  HomePageViewUITests.swift
//  MarvelUITests
//
//  Created by Bill on 10/7/25.
//

import XCTest

final class HomePageViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // Reset UserDefaults for a clean state
        app.launchArguments += ["--reset-userdefaults"]
        app.launchArguments.append("--ui-testing")
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    // Test: Home Page is always visible
    func testHomePageViewExists() throws {
        let homePageView = app.otherElements["HomePageView"]
        XCTAssertTrue(homePageView.waitForExistence(timeout: 5), "HomePageView should exist in the view hierarchy")
    }

    // Test: Marvel logo is always visible
    func testMarvelLogoExists() throws {
        let marvelLogo = app.images["marvelLogo"]
        XCTAssertTrue(marvelLogo.waitForExistence(timeout: 5), "Marvel logo should exist on the home page")
    }

    // Test: Character list loads at launch
    func testCharacterListLoads() throws {
        let characterList = app.otherElements["CharacterList"]
        XCTAssertTrue(characterList.waitForExistence(timeout: 5), "Character list should exist")
        let predicate = NSPredicate(format: "identifier BEGINSWITH %@", "CharacterCell_")
        let characterCells = app.otherElements.matching(predicate)
        let firstCharacter = characterCells.firstMatch
        XCTAssertTrue(firstCharacter.waitForExistence(timeout: 5), "At least one character cell should be loaded")
    }

    // Test: Adding a hero to the squad updates the squad section
    func testAddHeroToSquadFlow() throws {
        // 1. Go to character detail
        let predicate = NSPredicate(format: "identifier BEGINSWITH %@", "CharacterCell_")
        let characterCells = app.otherElements.matching(predicate)
        let firstCharacter = characterCells.firstMatch
        XCTAssertTrue(firstCharacter.waitForExistence(timeout: 5), "At least one character cell should be loaded")
        firstCharacter.tap()

        // 2. Tap add to squad
        let addToSquadButton = app.buttons["AddToSquadButton"]
        XCTAssertTrue(addToSquadButton.waitForExistence(timeout: 5), "Add to Squad button should exist")
        addToSquadButton.tap()

        // 3. Go back to home page (if needed)
        // Adjust navigation as per your app's navigation stack
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // 4. Now "My Squad" should appear
        let mySquadTitle = app.staticTexts["My Squad"]
        XCTAssertTrue(mySquadTitle.waitForExistence(timeout: 5), "My Squad title should be visible after adding a hero")
    }
    // Test: Adding a hero to the squad updates the squad section
    func testSquadMemberIsShowingAfterAdd() throws {
        // 1. Wait for the character list and tap the first character cell
        let predicate = NSPredicate(format: "identifier BEGINSWITH %@", "CharacterCell_")
        let characterCells = app.otherElements.matching(predicate)
        let firstCharacter = characterCells.firstMatch
        XCTAssertTrue(firstCharacter.waitForExistence(timeout: 5), "At least one character cell should be loaded")
        firstCharacter.tap()

        // 2. Tap the add to squad button on the character detail page
        let addToSquadButton = app.buttons["AddToSquadButton"]
        XCTAssertTrue(addToSquadButton.waitForExistence(timeout: 5), "Add to Squad button should exist")
        addToSquadButton.tap()

        // 3. Navigate back to the home page (adjust if your navigation is different)
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // 4. Check that a squad member cell is now visible
        let squadPredicate = NSPredicate(format: "identifier BEGINSWITH %@", "SquadCell_")
        let squadCell = app.otherElements.matching(squadPredicate).firstMatch
        XCTAssertTrue(squadCell.waitForExistence(timeout: 5), "A squad member cell should be visible after adding a character to the squad")
    }
}
