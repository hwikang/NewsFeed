//
//  NewsRepository.swift
//  NewsFeed
//
//  Created by paytalab on 5/7/24.
//

import Foundation
import CoreData
import UIKit

final class NewsRepository {
    private let viewContext: NSManagedObjectContext?
    private let network = NewsNetwork()

    init(viewContext: NSManagedObjectContext?) {
        self.viewContext = viewContext
     
    }
    
    public func getNews() async -> Result<[News], Error> {
        let result = await network.getNews()
        switch result {
        case let .success(news):
            updateNewsCoreData(news: news)
            return .success(news)
        case let .failure(error):
            let pastNews = readNewsCoreData()
            if pastNews.isEmpty {
                return .failure(error)
            } else {
                return .success(pastNews)
            }
        }
    }
    
    private func updateNewsCoreData(news: [News]) {
        deleteAllNewsCoreData()
        saveNewsCoreData(news: news)
    }
    
    private func deleteAllNewsCoreData() {
        let fetchRequestResult: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "NewsItem")

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequestResult)
        do {
            try viewContext?.execute(deleteRequest)
            try viewContext?.save()
        } catch let error {
            print("deleteAllNewsCoreData Error - \(error)")
        }
       
    }
    
    private func saveNewsCoreData(news: [News]) {
        guard let viewContext = viewContext,
            let entity = NSEntityDescription.entity(forEntityName: "NewsItem", in: viewContext) else { return }
      
        news.forEach { newsItem in
            let newsObject = NSManagedObject(entity: entity, insertInto: viewContext)
            newsObject.setValue(newsItem.publishedAt, forKey: "publishedAt")
            newsObject.setValue(newsItem.title, forKey: "title")
            newsObject.setValue(newsItem.urlToImage, forKey: "urlToImage")
            newsObject.setValue(newsItem.url, forKey: "url")
        }
        do {
            print("save news \(news.count)")
            try viewContext.save()
        } catch let error {
            print("saveNewsCoreData Error - \(error)")
        }
    }
    
    private func readNewsCoreData() -> [News] {
        let fetchRequest: NSFetchRequest<NewsItem> = NewsItem.fetchRequest()

        do {
            guard let result = try viewContext?.fetch(fetchRequest) else { return [] }
            let news: [News] = result.compactMap { news in
                guard let title = news.value(forKey: "title") as? String,
                  let url = news.value(forKey: "url") as? String else { return nil }

            let publishedAt = news.value(forKey: "publishedAt") as? Date
            let urlToImage = news.value(forKey: "urlToImage") as? String
                return News(title: title, url: url, urlToImage: urlToImage, publishedAt: publishedAt)
            }
            print("read news \(news.count) ")
            return news
        } catch let error {
            print("readNewsCoreData Error - \(error)")
            return []
        }

    }
    
}
