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
    let url = "https://gateway.marvel.com/v1/public/characters"
    let publicKey = "71e742407ca8b4ac76c4917a1c199a09"
    let privateKey = "67a407d72945a9b1ee019145174ae42a02b7117d"
    
    static let shared = APIManager()
    
    func fetchCharactedListData() async throws -> CharactersModel {
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
        
        let data: CharactersModel = try await networkService.fetchData(from: url, method: .get, headers: headers, parameters: parameters ,responseModel: CharactersModel.self)
        return data
    }
}

extension String {
var md5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
