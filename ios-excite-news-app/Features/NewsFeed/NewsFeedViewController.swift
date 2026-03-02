//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 02/03/26.
//

import UIKit
import Combine


final class NewsFeedViewController: UIViewController {
    private var viewModel: NewsFeedViewModel!
    private var cancellables = Set<AnyCancellable>()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NewsFeedViewModel(service: AppDependency.shared.newsService)
        bindViewModel()
        viewModel.loadFirstPage()
    }

    private func bindViewModel() {
        viewModel.articlesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                // self?.updateUI(for: state)
            }
            .store(in: &cancellables)
    }
}
