//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 02/03/26.
//

import UIKit
import Combine


final class ArticleDetailViewController: UIViewController {
    private let viewModel: ArticleDetailViewModel
    private var cancellables = Set<AnyCancellable>()

    init(article: Article) {
        self.viewModel = ArticleDetailViewModel(article: article)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Add WKWebView or native labels; share / open in Safari / bookmark buttons
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.articlePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // self?.updateContent()
            }
            .store(in: &cancellables)
    }
}
