//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 28/02/26.
//

import Foundation

struct Article: Codable, Equatable, Identifiable {
    let source: ArticleSource?
    let title: String?
    let articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    init(source: ArticleSource?, title: String?, articleDescription: String?, url: String?, urlToImage: String?, publishedAt: String?, content: String?) {
        self.source = source
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }

    var id: String { url ?? UUID().uuidString }

    enum CodingKeys: String, CodingKey {
        case source, title, url, urlToImage, publishedAt, content
        case articleDescription = "description"
    }
    var publishedDate: Date? {
        guard let publishedAt = publishedAt else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: publishedAt)
            ?? ISO8601DateFormatter().date(from: publishedAt)
    }

    var displayTitle: String { title ?? "Untitled" }
    var sourceName: String { source?.name ?? "Unknown" }
}

struct ArticleSource: Codable, Equatable {
    let id: String?
    let name: String?
}
