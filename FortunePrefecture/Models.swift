//
//  Models.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/02/29.
//

import Foundation

struct FortuneRequest: Codable {
    let name: String
    let birthday: YearMonthDay
    let blood_type: String
    let today: YearMonthDay
}

struct FortuneResponse: Codable {
    let name: String
    let capital: String
    let has_coast_line: Bool
    let logo_url: String
    let brief: String
}

struct FortuneResult: Codable,Hashable,Identifiable{
    let id: UUID
    let user_name: String
    let birthday: YearMonthDay
    let blood_type: String
    let today: YearMonthDay
    let prefecture: String
    let capital: String
    let has_coast_line: Bool
    let logo_url: String
    let brief: String
    let is_favorite: Bool
}

extension FortuneResponse {
    static var preview: FortuneResponse {
        let name: String = ""
        let capital: String = ""
        let has_coast_line: Bool  = true
        let logo_url: String = ""
        let brief: String = ""
        
        return FortuneResponse(name: name, capital: capital,  has_coast_line: has_coast_line, logo_url: logo_url, brief: brief)
    }
}

struct YearMonthDay: Codable,Hashable{
    let year: Int
    let month: Int
    let day: Int
    init(date: Date) {
        let calendar = Calendar.current
        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
    }
    func toDate() -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }
}

struct MonthDay: Codable,Hashable {
    let month: Int
    let day: Int
    init(date: Date){
        let calendar = Calendar.current
        self.month = calendar.component(.day, from: date)
        self.day = calendar.component(.day, from: date)
    }
}
