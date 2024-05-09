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
    private let news = PassthroughSubject<[News],Never>()
    private let visitedNewsIndex = CurrentValueSubject<Set<Int>,Never>([])

    private var cancellables = Set<AnyCancellable>()
    struct CellData {
        let news: News
        let selected: Bool
    }
    struct Input {
        let selectedIndex: AnyPublisher<Int,Never>
    }
    struct Output {
        let cellDataList: AnyPublisher<[CellData],Never>
    }
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
   
    public func transform(input: Input) -> Output {
        input.selectedIndex.sink { [weak self] index in
            guard let self = self else { return }
            visitedNewsIndex.value.insert(index)
            visitedNewsIndex.send(visitedNewsIndex.value)
        } .store(in: &cancellables)
        
        let cellDataList = news.combineLatest(visitedNewsIndex).map { news, visitedNewsIndex in
            let cellDataList = news.enumerated().map { index, newsItem in
                let isVisited = visitedNewsIndex.contains(index)
                return CellData(news: newsItem, selected: isVisited)
            }
            return cellDataList
        }.eraseToAnyPublisher()
        
        return Output(cellDataList: cellDataList)
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
