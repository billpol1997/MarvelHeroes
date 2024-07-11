//
//  HomePageUnitTests.swift
//  MarvelTests
//
//  Created by Vasilis Polyzos on 7/4/24.
//

import XCTest
@testable import Marvel

final class HomePageUnitTests: XCTestCase {

    //Arrange
    let homeVM = HomePageViewModel()
  
    func testSearchSquadMember() {
        
        //Arrange
        let character = Character(id: 1, name: "test", description: "1234", thumbnail: CharacterImage(path: "http://123456"))
        
        //Act
        homeVM.addSquadMember(character: character)
        let result = homeVM.searchSquadMember(character: character)
        
        //Assert
        XCTAssertTrue(result)
    }
    
    func testSearchSquadMemberError() {
        
        //Arrange
        let character = Character(id: 1, name: "test", description: "1234", thumbnail: CharacterImage(path: "http://123456"))
        
        //Act
        let result = homeVM.searchSquadMember(character: character)
        
        //Assert
        XCTAssertFalse(result)
    }
    
    func testHttpsConversionSuccessfully() {
        //Arrange
        let character = Character(id: 1, name: "test", description: "1234", thumbnail: CharacterImage(path: "http://123456"))
        
        //Act
        let result = homeVM.httpsConversion(url: character.thumbnail?.path ?? "")
        
        //Assert
        XCTAssertTrue(result.contains("https://"))
    }
    
    func testHttpsConversionFailed() {
        //Arrange
        let character = Character(id: 1, name: "test", description: "1234", thumbnail: CharacterImage(path: "testtesttest"))
        
        //Act
        let result = homeVM.httpsConversion(url: character.thumbnail?.path ?? "")
        
        //Assert
        XCTAssertFalse(result.contains("https://"))
    }
}
