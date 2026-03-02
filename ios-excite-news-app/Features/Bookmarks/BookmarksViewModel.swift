//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 02/03/26.
//

import Foundation
import Combine


final class BookmarksViewModel {
    @Published private(set) var bookmarkedArticles: [Article] = []

    var bookmarksPublisher: AnyPublisher<[Article], Never> {
        $bookmarkedArticles.eraseToAnyPublisher()
    }

    init() {
        // TODO: Load from UserDefaults / BookmarkStorage
    }

    func toggleBookmark(_ article: Article) {
        if let index = bookmarkedArticles.firstIndex(where: { $0.id == article.id }) {
            bookmarkedArticles.remove(at: index)
        } else {
            bookmarkedArticles.append(article)
        }
    }

    func isBookmarked(_ article: Article) -> Bool {
        bookmarkedArticles.contains { $0.id == article.id }
    }
}
