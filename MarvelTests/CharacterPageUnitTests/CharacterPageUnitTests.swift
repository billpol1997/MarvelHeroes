//
//  CharacterPageUnitTests.swift
//  MarvelTests
//
//  Created by Vasilis Polyzos on 7/4/24.
//

import XCTest
@testable import Marvel

final class CharacterPageUnitTests: XCTestCase {

    //Arrange
    let character = Character(id: 1, name: "test", description: "1234", thumbnail: CharacterImage(path: "http://123456"))
    let homeVM = HomePageViewModel()
    
    func testSquadPositivePositionStatusTest() {
        //Arrange
        let viewModel = CharacterPageViewModel(character: character, isInSquad: false, addSquadMember: {self.homeVM.addSquadMember(character: self.character)}, removeSquadMember: {self.homeVM.removeSquadMember(character: self.character)})
        //Act
        viewModel.changeSquadList()
        let isInSquad = viewModel.isInSquad
        
        //Assert
        XCTAssertTrue(isInSquad)
    }
    
    func testSquadPositionNegativeStatusTest() {
        //Arrange
        let viewModel = CharacterPageViewModel(character: character, isInSquad: true, addSquadMember: {self.homeVM.addSquadMember(character: self.character)}, removeSquadMember: {self.homeVM.removeSquadMember(character: self.character)})
        
        //Act
        viewModel.changeSquadList()
        let isInSquad = viewModel.isInSquad
        
        //Assert
        XCTAssertFalse(isInSquad)
    }

}
