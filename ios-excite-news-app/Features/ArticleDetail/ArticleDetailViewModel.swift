//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 02/03/26.
//

import Foundation
import Combine

final class ArticleDetailViewModel {
    @Published private(set) var article: Article

    var articlePublisher: AnyPublisher<Article, Never> {
        $article.eraseToAnyPublisher()
    }

    init(article: Article) {
        self.article = article
    }

    func openInSafari() {
        guard let urlString = article.url, let url = URL(string: urlString) else { return }
        // View will perform UIApplication.shared.open(url)
    }
    func shareURL() -> URL? {
        guard let urlString = article.url else { return nil }
        return URL(string: urlString)
    }
}
