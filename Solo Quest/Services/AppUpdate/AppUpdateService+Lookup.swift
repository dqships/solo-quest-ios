//
//  AppUpdateService+Lookup.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-28-2026
//

import Foundation

extension AppUpdateService {
    func latestAppStoreVersion(for bundleIdentifier: String) async throws -> AppStoreVersionResult? {
        var components = URLComponents(string: "https://itunes.apple.com/lookup")
        components?.queryItems = [
            URLQueryItem(name: "bundleId", value: bundleIdentifier),
            URLQueryItem(name: "country", value: locale.region?.identifier ?? "US")
        ]

        guard let url = components?.url else { return nil }

        var request = URLRequest(url: url, timeoutInterval: 5)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try decoder.decode(AppStoreLookupResponse.self, from: data).results.first
    }
}
