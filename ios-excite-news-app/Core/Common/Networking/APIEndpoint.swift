//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 01/03/26.
//

import Foundation

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
}

extension APIEndpoint {
    var baseURL: URL {
        URL(string: "https://newsapi.org/v2")!
    }

    var headers: [String: String]? {
        ["Accept": "application/json", "Content-Type": "application/json"]
    }

    func makeRequest() throws -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        var allItems = queryItems ?? []
        if let key = APIConfiguration.newsAPIKey {
            allItems.append(URLQueryItem(name: "apiKey", value: key))
        }
        components.queryItems = allItems.isEmpty ? nil : allItems
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct NewsTopHeadlinesEndpoint: APIEndpoint {
    let path = "/top-headlines"
    let method: HTTPMethod = .get
    let country: String?
    let category: String?
    let page: Int
    let pageSize: Int

    init(country: String? = "us", category: String? = nil, page: Int = 1, pageSize: Int = 20) {
        self.country = country
        self.category = category
        self.page = page
        self.pageSize = pageSize
    }

    var queryItems: [URLQueryItem]? {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "pageSize", value: "\(pageSize)")
        ]
        if let country = country { items.append(URLQueryItem(name: "country", value: country)) }
        if let category = category { items.append(URLQueryItem(name: "category", value: category)) }
        return items
    }
}

struct NewsSearchEndpoint: APIEndpoint {
    let path = "/everything"
    let method: HTTPMethod = .get
    let query: String
    let page: Int
    let pageSize: Int
    let sortBy: String?

    init(query: String, page: Int = 1, pageSize: Int = 20, sortBy: String? = "publishedAt") {
        self.query = query
        self.page = page
        self.pageSize = pageSize
        self.sortBy = sortBy
    }

    var queryItems: [URLQueryItem]? {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "pageSize", value: "\(pageSize)")
        ]
        if let sortBy = sortBy { items.append(URLQueryItem(name: "sortBy", value: sortBy)) }
        return items
    }
}

protocol GNewsEndpoint {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    func makeRequest() throws -> URLRequest
}

extension GNewsEndpoint {
    var baseURL: URL {
        URL(string: "https://gnews.io/api/v4")!
    }

    func makeRequest() throws -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        var items = queryItems
        if let key = APIConfiguration.gnewsAPIKey {
            items.append(URLQueryItem(name: "apikey", value: key))
        }
        components.queryItems = items.isEmpty ? nil : items
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

struct GNewsTopHeadlinesEndpoint: GNewsEndpoint {
    let path = "top-headlines"
    let country: String?
    let category: String?
    let lang: String?
    let max: Int
    let page: Int
    let q: String?

    init(country: String? = "us", category: String? = nil, lang: String? = "en", max: Int = 20, page: Int = 1, q: String? = nil) {
        self.country = country
        self.category = category
        self.lang = lang
        self.max = min(max, 100)
        self.page = page
        self.q = q
    }

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "max", value: "\(max)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        if let country = country { items.append(URLQueryItem(name: "country", value: country)) }
        if let category = category { items.append(URLQueryItem(name: "category", value: category)) }
        if let lang = lang { items.append(URLQueryItem(name: "lang", value: lang)) }
        if let q = q, !q.isEmpty { items.append(URLQueryItem(name: "q", value: q)) }
        return items
    }
}

struct GNewsSearchEndpoint: GNewsEndpoint {
    let path = "search"
    let q: String
    let lang: String?
    let country: String?
    let max: Int
    let page: Int
    let sortBy: String?

    init(q: String, lang: String? = "en", country: String? = nil, max: Int = 20, page: Int = 1, sortBy: String? = "publishedAt") {
        self.q = q
        self.lang = lang
        self.country = country
        self.max = min(max, 100)
        self.page = page
        self.sortBy = sortBy
    }

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "max", value: "\(max)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        if let lang = lang { items.append(URLQueryItem(name: "lang", value: lang)) }
        if let country = country { items.append(URLQueryItem(name: "country", value: country)) }
        if let sortBy = sortBy { items.append(URLQueryItem(name: "sortby", value: sortBy)) }
        return items
    }
}
