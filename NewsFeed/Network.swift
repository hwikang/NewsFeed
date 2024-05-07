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


final class NewsNetwork {
    private let module = Network()
    public func getNews() async -> Result<[News], Error> {
        let result = await module.requestAPI(path: "top-headlines", method: .get)
        switch result {
        case .success(let data):
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let articles = json["articles"] as? [[String: Any]],
                  let articlesData = try? JSONSerialization.data(withJSONObject: articles, options: .prettyPrinted),
                  let news = try? JSONDecoder().decode([News].self, from: articlesData) else {
                return .failure(NetworkError.responseParsingError)
            }
           
            return .success(news)
           
        case .failure(let error):
            return .failure(error)
        }
    }
}

enum NetworkError: Error {
    case responseParsingError
}
