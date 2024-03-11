//
//  APIModels.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/03/12.
//

import Foundation

struct FortuneResponse: Codable {
    let name: String
    let capital: String
    let has_coast_line: Bool
    let citizen_day: MonthDay?
    let logo_url: String
    let brief: String
}

struct FortuneRequest: Codable {
    let name: String
    let birthday: YearMonthDay
    let blood_type: String
    let today: YearMonthDay
}
