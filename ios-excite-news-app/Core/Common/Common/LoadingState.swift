//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 01/03/26.
//


import Foundation

enum LoadingState<Value, Failure: Error> {
    case idle
    case loading
    case loaded(Value)
    case failed(Failure)
}

extension LoadingState {
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var value: Value? {
        if case .loaded(let v) = self { return v }
        return nil
    }

    var error: Failure? {
        if case .failed(let e) = self { return e }
        return nil
    }
}
