//
//  CharactersModel.swift
//  Marvel
//
//  Created by Vasilis Polyzos on 5/4/24.
//

import Foundation

struct CharactersModel: Decodable {
    let data: CharacterResultsModel?
}

struct CharacterResultsModel: Decodable {
    let results: [Character]?
}

struct Character: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: CharacterImage?
}

struct CharacterImage: Decodable {
    let path: String?
}

struct SquadModel: Codable {
    let id: Int
    let name: String
    let description: String
    let image: String
    
    init(from char: Character) {
        self.id = char.id ?? 0
        self.name = char.name ?? ""
        self.description = char.description ?? ""
        self.image = char.thumbnail?.path ?? ""
    }
}
