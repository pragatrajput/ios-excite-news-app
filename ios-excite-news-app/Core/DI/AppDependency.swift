//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 01/03/26.
//


import Foundation

struct AppDependency {
    let apiClient: APIClientProtocol
    let newsService: NewsAPIServiceProtocol

    static var shared: AppDependency = .live

    static let live: AppDependency = {
        let client = URLSessionAPIClient()
        let news = NewsAPIService(client: client)
        return AppDependency(apiClient: client, newsService: news)
    }()

    static func mock(apiClient: APIClientProtocol, newsService: NewsAPIServiceProtocol) -> AppDependency {
        AppDependency(apiClient: apiClient, newsService: newsService)
    }
}
