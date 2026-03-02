//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 02/03/26.
//

import Foundation
import Combine

@MainActor
final class NewsFeedViewModel: ObservableObject {
    // MARK: - Input (View calls these)
    func loadFirstPage() { Task { await loadPage(1) } }
    func loadNextPage() { Task { await loadPage(currentPage + 1) } }
    func search(query: String) { searchQuery = query; Task { await loadSearchPage(1) } }
    func refresh() { Task { await loadPage(1) } }

    // MARK: - Output (View reads these; SwiftUI updates when they change)
    @Published private(set) var state: LoadingState<[Article], APIError> = .idle
    @Published private(set) var articles: [Article] = []
    @Published private(set) var hasMorePages = true

    /// For UIKit: subscribe to updates. SwiftUI uses @Published via @StateObject.
    var articlesPublisher: AnyPublisher<[Article], Never> { $articles.eraseToAnyPublisher() }
    var statePublisher: AnyPublisher<LoadingState<[Article], APIError>, Never> { $state.eraseToAnyPublisher() }

    private let service: NewsAPIServiceProtocol
    private var currentPage = 1
    private var searchQuery: String?
    private let pageSize = 20

    init(service: NewsAPIServiceProtocol = NewsAPIService()) {
        self.service = service
    }

    /// Loads a page of top headlines. Updates state on the main actor.
    private func loadPage(_ page: Int) async {
        if page == 1 { state = .loading }
        currentPage = page

        do {
            let response = try await service.fetchTopHeadlines(country: "us", category: nil, page: page, pageSize: pageSize)
            let newItems = response.articles
            if page == 1 {
                articles = newItems
            } else {
                articles.append(contentsOf: newItems)
            }
            state = .loaded(articles)
            // Simple pagination rule: if we received a full page, assume there may be more.
            hasMorePages = newItems.count == pageSize
        } catch let error as APIError {
            state = .failed(error)
        } catch {
            state = .failed(.unknown(error))
        }
    }

    /// Loads a page of search results. Falls back to headlines if query is empty.
    private func loadSearchPage(_ page: Int) async {
        guard let query = searchQuery, !query.isEmpty else {
            await loadPage(1)
            return
        }
        if page == 1 { state = .loading }

        do {
            let response = try await service.search(query: query, page: page, pageSize: pageSize)
            let newItems = response.articles
            if page == 1 {
                articles = newItems
            } else {
                articles.append(contentsOf: newItems)
            }
            state = .loaded(articles)
            hasMorePages = newItems.count == pageSize
        } catch let error as APIError {
            state = .failed(error)
        } catch {
            state = .failed(.unknown(error))
        }
    }
}
