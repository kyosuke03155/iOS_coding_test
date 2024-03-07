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

enum BloodTypes: String, CaseIterable, Identifiable {
    case A = "A"
    case B = "B"
    case AB = "AB"
    case O = "O"
    
    var id: Self { self }
}

struct Person: Identifiable, Codable,Hashable {
    var id = UUID()
    var name: String
    var birthday: YearMonthDay
    var blood_type: String
    //var today: YearMonthDay
    var today: Date
    var prefecture: Prefecture?
    var is_favorite: Bool = false
    
    // イニシャライザを使用して初期値を設定
    init(id: UUID = UUID(),
        name: String = "ゆめみん",
         birthday: YearMonthDay = YearMonthDay(year: 1990, month: 1, day: 1),
         bloodType: String = "AB",
         today: Date = Date(),
         prefecture: Prefecture? = nil,
         isFavorite: Bool = false
    ) {
        self.id = id
        self.name = name
        self.birthday = birthday
        self.blood_type = bloodType
        self.today = today
        self.prefecture = prefecture
        self.is_favorite = isFavorite
    }
}

struct Prefecture: Codable,Hashable,Identifiable{
    var id = UUID()
    var name: String
    var capital: String
    var citizen_day: MonthDay?
    var has_coast_line: Bool
    var logo_url: String
    var brief: String
    
    
    // デフォルト値を持つイニシャライザ
    init(id: UUID = UUID(),
        name: String = "富山県",
         capital: String = "富山市",
         citizen_day: MonthDay? = nil, // 県民の日は必ずしも存在しないため、nilをデフォルト値とします。
         has_coast_line: Bool = true,
         logo_url: String = "https://japan-map.com/wp-content/uploads/toyama.png",
         brief: String = "富山県（とやまけん）は、日本の中部地方に位置する県。県庁所在地は富山市。\n中部地方の日本海側、新潟県を含めた場合の北陸地方のほぼ中央にある。\n※出典: フリー百科事典『ウィキペディア（Wikipedia）』") {
        self.id = id
        self.name = name
        self.capital = capital
        self.citizen_day = citizen_day
        self.has_coast_line = has_coast_line
        self.logo_url = logo_url
        self.brief = brief
    }
}


struct FortuneResponse: Codable {
    let name: String
    let capital: String
    let has_coast_line: Bool
    let citizen_day: MonthDay?
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
    init(year: Int, month: Int, day: Int){
        self.year = year
        self.month = month
        self.day = day
    }
    func toDate() -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }
    func toString() -> String {
        return "\(year)年\(month)月\(day)日"
    }
    
}

extension YearMonthDay: Comparable {
    static func < (lhs: YearMonthDay, rhs: YearMonthDay) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            return lhs.month < rhs.month
        } else {
            return lhs.day < rhs.day
        }
    }
}

struct MonthDay: Codable,Hashable {
    let month: Int
    let day: Int
    init(date: Date){
        let calendar = Calendar.current
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
    }
    func toDate() -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = 2000
        dateComponents.month = month
        dateComponents.day = day
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }
    func toString() -> String {
        return "\(month)月\(day)日"
    }
}
