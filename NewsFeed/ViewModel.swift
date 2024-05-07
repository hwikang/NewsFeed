//
//  ViewModel.swift
//  NewsFeed
//
//  Created by paytalab on 5/7/24.
//

import UIKit
import Combine

final class ViewModel {
    private let repository: NewsRepository
    init(repository: NewsRepository) {
        self.repository = repository
        getNews()
    }
   
    private let news = PassthroughSubject<[News],Never>()
    private let visitedNewsIndex = PassthroughSubject<[Int],Never>()

    struct Output {
        let news: AnyPublisher<[News],Never>
    }
    
    public func transform() -> Output {
        return Output(news: news.eraseToAnyPublisher())
    }
    
    public func getNews() {
        Task { [weak self] in
            guard let self = self else { return }
            let data = await self.repository.getNews()
            switch data {
            case .success(let news):
                self.news.send(news)
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
}
