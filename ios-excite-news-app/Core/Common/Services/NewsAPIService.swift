//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 01/03/26.
//

import Foundation


protocol NewsAPIServiceProtocol: AnyObject {
    func fetchTopHeadlines(country: String?, category: String?, page: Int, pageSize: Int) async throws -> NewsResponse
    func search(query: String, page: Int, pageSize: Int) async throws -> NewsResponse
}

final class NewsAPIService: NewsAPIServiceProtocol {
    private let client: APIClientProtocol

    init(client: APIClientProtocol = URLSessionAPIClient()) {
        self.client = client
    }

    func fetchTopHeadlines(country: String? = "in", category: String? = nil, page: Int = 1, pageSize: Int = 20) async throws -> NewsResponse {
        let endpoint = GNewsTopHeadlinesEndpoint(country: country, category: category, max: pageSize, page: page)
        let gnews = try await client.requestGNews(endpoint)
        let articles = gnews.articles.map { $0.toArticle() }
        return NewsResponse(articles: articles)
    }

    func search(query: String, page: Int = 1, pageSize: Int = 20) async throws -> NewsResponse {
        let endpoint = GNewsSearchEndpoint(q: query, max: pageSize, page: page)
        let gnews = try await client.requestGNews(endpoint)
        let articles = gnews.articles.map { $0.toArticle() }
        return NewsResponse(articles: articles)
    }
}
