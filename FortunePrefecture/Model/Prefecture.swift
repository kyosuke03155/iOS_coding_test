//
//  Prefecture.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/03/12.
//

import Foundation

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
