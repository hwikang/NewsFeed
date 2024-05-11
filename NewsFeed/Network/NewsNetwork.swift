//
//  NewsNetwork.swift
//  NewsFeed
//
//  Created by paytalab on 5/11/24.
//

import Foundation

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
