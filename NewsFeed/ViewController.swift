//
//  ViewController.swift
//  NewsFeed
//
//  Created by paytalab on 5/7/24.
//

import UIKit

class ViewController: UIViewController {
    private let network: NewsNetwork = NewsNetwork()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      print("Test")
        Task {
            let data = await network.getNews()
            switch data {
            case .success(let news):
                print("data \(news)")
            case .failure(let error):
                print("data \(error)")

            }
        }
    }


}

