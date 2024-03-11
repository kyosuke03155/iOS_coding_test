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
}
