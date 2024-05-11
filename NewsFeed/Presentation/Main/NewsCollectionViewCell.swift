//
//  NewsCollectionViewCell.swift
//  NewsFeed
//
//  Created by paytalab on 5/8/24.
//

import UIKit

final class NewsCollectionViewCell: UICollectionViewCell {
    static let id = "NewsCollectionViewCell"
    private let imageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        return imageView
    }()
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    private let publishedAtLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .thin)
        label.textAlignment = .right
        return label
    }()
    
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
    
    public func apply(imageURL: String?, title: String, publishedAt: Date?, isSelected: Bool) {
        setImage(imageURL: imageURL)
        publishedAtLabel(publishedAt: publishedAt)
        setTitleLabel(title: title, isSelected: isSelected)
    }
    
    private func setImage(imageURL: String?) {
        if let imageURL = imageURL, !imageURL.isEmpty {
            imageView.setImage(imageURLSring: imageURL)
        } else {
            imageView.image = nil
        }
    }
    
    private func setTitleLabel(title: String, isSelected: Bool) {
        titleLabel.text = title
        if isSelected {
            titleLabel.textColor = .red
        } else {
            titleLabel.textColor = .label
        }
    }
    
    private func publishedAtLabel(publishedAt: Date?) {
        if let publishedAt = publishedAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            publishedAtLabel.text = dateFormatter.string(from: publishedAt)
        } else {
            publishedAtLabel.text = nil
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


