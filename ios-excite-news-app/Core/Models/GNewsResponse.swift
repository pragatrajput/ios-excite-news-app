//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 28/02/26.
//

import Foundation

struct GNewsResponse: Codable {
    let articles: [GNewsArticle]
}

struct GNewsArticle: Codable {
    let id: String?
    let title: String?
    let description: String?
    let content: String?
    let url: String?
    let image: String?
    let publishedAt: String?
    let lang: String?
    let source: GNewsSource?
}

struct GNewsSource: Codable {
    let id: String?
    let name: String?
    let url: String?
    let country: String?
}


extension GNewsArticle {
    func toArticle() -> Article {
        Article(
            source: source?.toArticleSource(),
            title: title,
            articleDescription: description,
            url: url,
            urlToImage: image,
            publishedAt: publishedAt,
            content: content
        )
    }
}

extension GNewsSource {
    func toArticleSource() -> ArticleSource {
        ArticleSource(id: id, name: name)
    }
}
