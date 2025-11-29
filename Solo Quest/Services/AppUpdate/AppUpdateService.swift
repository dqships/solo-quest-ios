//
//  AppUpdateService.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-28-2026
//

import Foundation

final class AppUpdateService {
    let bundle: Bundle
    let decoder: JSONDecoder
    let locale: Locale
    let session: URLSession

    init(
        bundle: Bundle = .main,
        decoder: JSONDecoder = JSONDecoder(),
        locale: Locale = .current,
        session: URLSession = .shared
    ) {
        self.bundle = bundle
        self.decoder = decoder
        self.locale = locale
        self.session = session
    }
}
