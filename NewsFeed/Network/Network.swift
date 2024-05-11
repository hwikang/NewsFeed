//
//  Network.swift
//  NewsFeed
//
//  Created by paytalab on 5/7/24.
//

import Foundation
import Alamofire

final class Network {
    private let urlPrefix = "https://newsapi.org/v2/"
    private let session = Session(configuration: .default)
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    
    public func requestAPI(path: String, method: HTTPMethod) async -> Result<Data, AFError> {
        let url = urlPrefix + path + "?country=kr&apiKey=" + apiKey
        let response =  await session.request(url, method: method).validate().serializingData().response
        return response.result
    }
}

enum NetworkError: Error {
    case responseParsingError
}
