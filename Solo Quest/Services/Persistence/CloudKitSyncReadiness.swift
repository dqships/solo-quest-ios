//
//  CloudKitSyncReadiness.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

final class CloudKitSyncReadiness {
    private(set) var didLoadStore = false
    private(set) var didFinishInitialImport = false
    private(set) var loadErrorDescription: String?
    private(set) var importErrorDescription: String?

    var isReadyForDailyReset: Bool {
        didLoadStore &&
            didFinishInitialImport &&
            loadErrorDescription == nil &&
            importErrorDescription == nil
    }

    func markStoreLoaded() { didLoadStore = true }
    func markInitialImportFinished() {
        didFinishInitialImport = true
        importErrorDescription = nil
    }
    func recordImportFailure(_ error: Error?) {
        importErrorDescription = error?.localizedDescription ?? "CloudKit import did not succeed."
    }
    func recordLoadError(_ error: Error) { loadErrorDescription = error.localizedDescription }
}
