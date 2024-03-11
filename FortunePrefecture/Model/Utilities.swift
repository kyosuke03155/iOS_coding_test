//
//  Models.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/02/29.
//

import Foundation


enum BloodTypes: String, CaseIterable, Identifiable {
    case A = "A"
    case B = "B"
    case AB = "AB"
    case O = "O"
    
    var id: Self { self }
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
