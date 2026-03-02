//
//  Model.swift
//  ios-excite-news-app
//
//  Created by Pragat Rajput on 02/03/26.
//

import SwiftUI

struct NewsFeedView: View {
    @StateObject private var viewModel = NewsFeedViewModel(service: AppDependency.shared.newsService)

    var body: some View {
        Group {
            if APIConfiguration.gnewsAPIKey == nil {
                apiKeyPlaceholder
            } else {
                listContent
            }
        }
        .navigationTitle("News")
        .refreshable {
            viewModel.refresh()
        }
        .onAppear {
            if APIConfiguration.gnewsAPIKey != nil {
                viewModel.loadFirstPage()
            }
        }
    }

    private var apiKeyPlaceholder: some View {
        VStack(spacing: 16) {
            Image(systemName: "key.fill")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("API key required")
                .font(.title2)
            Text("Set API_KEY in the scheme.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var listContent: some View {
        switch viewModel.state {
        case .idle, .loading where viewModel.articles.isEmpty:
            Group {
                ProgressView("Loading…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        case .failed(let error):
            Group {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.orange)
                    Text(error.localizedDescription)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    if (error as? APIError)?.isUnauthorized == true {
                        Text("Check: Edit Scheme → Run → Arguments → Environment Variables. Name: GNEWS_API_KEY. No extra spaces.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    Button("Retry") { viewModel.refresh() }
                        .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        case .loaded, .loading:
            Group {
                List {
                    ForEach(viewModel.articles) { article in
                        ArticleRowView(article: article)
                    }
                    if viewModel.hasMorePages && !viewModel.articles.isEmpty {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .onAppear { viewModel.loadNextPage() }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

struct ArticleRowView: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let urlString = article.urlToImage, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "photo").foregroundStyle(.secondary)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 160)
                .clipped()
            }
            Text(article.displayTitle)
                .font(.headline)
                .lineLimit(2)
            HStack {
                Text(article.sourceName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if let date = article.publishedDate {
                    Text(date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        NewsFeedView()
    }
}
