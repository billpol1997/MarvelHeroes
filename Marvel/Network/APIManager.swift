//
//  APIManager.swift
//  Marvel
//
//  Created by Vasilis Polyzos on 5/4/24.
//

import Foundation
import Alamofire
import CryptoKit

final class APIManager {
    let networkService = GenericAPICall()
    let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String
    let publicKey = Bundle.main.object(forInfoDictionaryKey: "API_PUBLIC_KEY") as? String
    let privateKey = Bundle.main.object(forInfoDictionaryKey: "API_PRIVATE_KEY") as? String
    
    static let shared = APIManager()
    
    func fetchCharactedListData() async throws -> CharactersModel {
        if let url = url, let publicKey = publicKey, let privateKey = privateKey {
            let headers: HTTPHeaders = [
                "accept" : "application/json"
            ]
            
            let timestamp = String(NSDate().timeIntervalSince1970)
            let hash = (timestamp + privateKey + publicKey).md5
            
            let parameters: Parameters = [
                "apikey": publicKey,
                "ts": timestamp,
                "hash": hash
            ]
            
            let data: CharactersModel? = try? await networkService.fetchData(from: url, method: .get, headers: headers, parameters: parameters ,responseModel: CharactersModel.self)
            if let data {
                return data
            } else {
                return try await fetchFromJSON()
            }
        } else {
            return try await fetchFromJSON()
        }
    }
    
    func fetchFromJSON() async throws -> CharactersModel {
        // Fallback: Load from local JSON
        guard let path = Bundle.main.path(forResource: "characters", ofType: "json") else {
            throw NSError(domain: "APIManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Local JSON file not found"])
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let decoded = try JSONDecoder().decode(CharactersModel.self, from: data)
        return decoded
    }
}

extension String {
var md5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
