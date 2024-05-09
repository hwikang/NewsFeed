//
//  NewsCollectionViewCell.swift
//  NewsFeed
//
//  Created by paytalab on 5/8/24.
//

import UIKit

final class NewsCollectionViewCell: UICollectionViewCell {
    static let id = "NewsCollectionViewCell"
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
