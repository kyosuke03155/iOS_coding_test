//
//  Person.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/03/12.
//

import Foundation

struct Person: Identifiable, Codable,Hashable {
    var id = UUID()
    var name: String
    var birthday: Date
    var blood_type: String
    var today: Date
    var prefecture: Prefecture?
    var is_favorite: Bool = false
    
    // イニシャライザを使用して初期値を設定
    init(id: UUID = UUID(),
         name: String = "ゆめみん",
         birthday: Date = Date(),
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
    
    func formatDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        // 日付のフォーマットを設定します。例: "yyyy年MM月dd日"
        formatter.dateFormat = "yyyy年MM月dd日"
        // 日付を文字列に変換します。
        return formatter.string(from: date)
    }
    
    // 誕生日を文字列に変換するためのプロパティ
    var birthdayString: String {
        formatDateToString(birthday)
    }
    
    // 今日の日付を文字列に変換するためのプロパティ
    var todayString: String {
        formatDateToString(today)
    }
}

extension Array where Element == Person {
    func sortedByPrefectureOrder() -> [Person] {
        self.sorted { (person1, person2) -> Bool in
            let order1 = PrefectureOrder.getOrder(of: person1.prefecture?.name ?? "")
            let order2 = PrefectureOrder.getOrder(of: person2.prefecture?.name ?? "")
            return order1 < order2
        }
    }
}
