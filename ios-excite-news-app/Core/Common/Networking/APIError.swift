//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 28/02/26.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, data: Data?)
    case decodingError(Error)
    case networkError(Error)
    case unknown(Error?)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .invalidResponse:
            return "Invalid response from server."
        case .httpError(let code, let data):
            if let message = Self.parseGNewsError(data) {
                return "\(message) (HTTP \(code))"
            }
            return "HTTP error: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unknown(let error):
            return error?.localizedDescription ?? "An unknown error occurred."
        }
    }

    /// True when the API returned 401 (invalid or missing key).
    var isUnauthorized: Bool {
        if case .httpError(401, _) = self { return true }
        return false
    }

    /// GNews returns { "errors": [ "Your API key is invalid." ] }
    private static func parseGNewsError(_ data: Data?) -> String? {
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let errors = json["errors"] as? [String],
              let first = errors.first else { return nil }
        return first
    }
}
