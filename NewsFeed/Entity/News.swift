//
//  News.swift
//  NewsFeed
//
//  Created by paytalab on 5/7/24.
//

import Foundation

public struct News: Decodable, Hashable {
    public let title: String
    public let url: String
    public let urlToImage: String?
    public let publishedAt: Date?
    
    enum CodingKeys: CodingKey {
        case title
        case url
        case urlToImage
        case publishedAt
    }
    
    init(title: String, url: String, urlToImage: String?, publishedAt: Date?) {
        self.title = title
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(String.self, forKey: .url)
        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        let publisedAtString = try container.decode(String.self, forKey: .publishedAt)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.publishedAt = dateFormatter.date(from: publisedAtString)
        
    }
}
