//
//  DataFactory.swift
//  Marvel
//
//  Created by Vasilis Polyzos on 11/4/24.
//

import Foundation

final class DataFactory {
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    func httpsConversion(url: String) -> String {
        return "https" + url.dropFirst(4)
    }
    
    func characterToSquad(character: Character) -> SquadModel {
        return SquadModel(from: character)
    }
    
    func loadSquadMembers() -> [SquadModel] {
        if let data = defaults.data(forKey: "Squad") {
            do {
                let squad = try decoder.decode([SquadModel].self, from: data)
                return squad
            }
            catch {
                print("Unable to deccode Note (\(error))")
            }
        }
        return []
    }
    
    func updateSquadList(list: [SquadModel]) {
        defaults.removeObject(forKey: "Squad")
        do {
            let squad = try encoder.encode(list)
            defaults.setValue(squad, forKey: "Squad")
        }
        catch {
            print("Unable to Encode Note (\(error))")
        }
    }
}
