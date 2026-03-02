//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 01/03/26.
//

import Foundation

enum APIConfiguration {
    static var newsAPIKey: String? {
        ProcessInfo.processInfo.environment["NEWS_API_KEY"]
            ?? Bundle.main.object(forInfoDictionaryKey: "NEWS_API_KEY") as? String
    }

    static var gnewsAPIKey: String? {
        let fromEnv = ProcessInfo.processInfo.environment["GNEWS_API_KEY"]
        return (fromEnv?.isEmpty == false) ? fromEnv : nil
    }
}
