//
//  ViewController.swift
//  NewsFeed
//
//  Created by paytalab on 5/7/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private let viewModel: ViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform()
        output.news.receive(on: DispatchQueue.main)
            .sink { news in
                //TODO: 콜렉션뷰 구현
                print("NEWS \(news)")
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


