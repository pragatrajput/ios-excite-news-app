//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 01/03/26.
//

import Foundation

protocol APIClientProtocol: AnyObject {
    func requestGNews(_ endpoint: GNewsEndpoint) async throws -> GNewsResponse
}

final class URLSessionAPIClient: APIClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func requestGNews(_ endpoint: GNewsEndpoint) async throws -> GNewsResponse {
        let request = try endpoint.makeRequest()
        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200..<300).contains(http.statusCode) else {
            throw APIError.httpError(statusCode: http.statusCode, data: data)
        }

        do {
            return try decoder.decode(GNewsResponse.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
