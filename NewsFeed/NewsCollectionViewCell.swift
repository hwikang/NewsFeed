//
//  NewsCollectionViewCell.swift
//  NewsFeed
//
//  Created by paytalab on 5/8/24.
//

import UIKit

final class NewsCollectionViewCell: UICollectionViewCell {
    static let id = "NewsCollectionViewCell"
    private let imageView = UIImageView()
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    private let publishedAtLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .thin)
        label.textAlignment = .right
        return label
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(publishedAtLabel)
        imageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(10)
            make.width.equalTo(100)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(20)
            make.top.trailing.equalToSuperview().inset(10)
        }
        publishedAtLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(20)
            make.bottom.trailing.equalToSuperview().inset(10)
        }
    }
    
    public func apply(imageURL: String?, title: String, publishedAt: Date?) {
        if let imageURL = imageURL {
            imageView.setImage(imageURLSring: imageURL)
        }
        titleLabel.text = title
    
        if let publishedAt = publishedAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            publishedAtLabel.text = dateFormatter.string(from: publishedAt)
        }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


