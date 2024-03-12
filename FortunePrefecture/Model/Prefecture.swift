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

struct PrefectureOrder {
    static let order: [String: Int] = [
        "北海道": 1,
        "青森県": 2,
        "岩手県": 3,
        "宮城県": 4,
        "秋田県": 5,
        "山形県": 6,
        "福島県": 7,
        "茨城県": 8,
        "栃木県": 9,
        "群馬県": 10,
        "埼玉県": 11,
        "千葉県": 12,
        "東京都": 13,
        "神奈川県": 14,
        "新潟県": 15,
        "富山県": 16,
        "石川県": 17,
        "福井県": 18,
        "山梨県": 19,
        "長野県": 20,
        "岐阜県": 21,
        "静岡県": 22,
        "愛知県": 23,
        "三重県": 24,
        "滋賀県": 25,
        "京都府": 26,
        "大阪府": 27,
        "兵庫県": 28,
        "奈良県": 29,
        "和歌山県": 30,
        "鳥取県": 31,
        "島根県": 32,
        "岡山県": 33,
        "広島県": 34,
        "山口県": 35,
        "徳島県": 36,
        "香川県": 37,
        "愛媛県": 38,
        "高知県": 39,
        "福岡県": 40,
        "佐賀県": 41,
        "長崎県": 42,
        "熊本県": 43,
        "大分県": 44,
        "宮崎県": 45,
        "鹿児島県": 46,
        "沖縄県": 47
    ]


    static func getOrder(of prefectureName: String) -> Int {
        return order[prefectureName] ?? 48
    }
}

extension Array where Element == Prefecture {
    func sortedByPrefectureOrder() -> [Prefecture] {
        self.sorted { (prefecture1, prefecture2) -> Bool in
            let order1 = PrefectureOrder.getOrder(of: prefecture1.name)
            let order2 = PrefectureOrder.getOrder(of: prefecture2.name)
            return order1 < order2
        }
    }
}
