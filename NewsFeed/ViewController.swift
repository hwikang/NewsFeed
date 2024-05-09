//
//  ViewController.swift
//  NewsFeed
//
//  Created by paytalab on 5/7/24.
//

import UIKit
import Combine
import SnapKit

class ViewController: UIViewController, UICollectionViewDelegate {
    private let viewModel: ViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.id)
        collectionView.delegate = self
        return collectionView
    }()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        viewModel.getNews()
    }
    
    private func setUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        setDataSource()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform()
        output.news.receive(on: DispatchQueue.main)
            .sink { [weak self] news in
               
                var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
               let items = news.map { Item.news($0) }
                let section = Section.list
               snapshot.appendSections([section])
               snapshot.appendItems(items, toSection: section)
               self?.dataSource?.apply(snapshot)
            }
            .store(in: &cancellables)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            let size = environment.container.effectiveContentSize
            let isLandscape = size.width > size.height
            if isLandscape {
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1540), heightDimension: .absolute(120))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 5)
                group.interItemSpacing = .fixed(10)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                return section
            }
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] context in
            guard let self = self else { return }
            self.collectionView.collectionViewLayout = self.createLayout()
        }
    }
    
    private func setDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.id, for: indexPath) as? NewsCollectionViewCell
            if case let .news(newsItem) = item {
                cell?.apply(imageURL: newsItem.urlToImage, title: newsItem.title, publishedAt: newsItem.publishedAt)
            }
           
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if case let .news(newsItem) = dataSource?.itemIdentifier(for: indexPath) {
            
            let webViewController = WebViewController(titleString: newsItem.title, urlString: newsItem.url)
            navigationController?.pushViewController(webViewController, animated: true)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

fileprivate enum Section {
    case list
}

fileprivate enum Item: Hashable {
    case news(News)
}
