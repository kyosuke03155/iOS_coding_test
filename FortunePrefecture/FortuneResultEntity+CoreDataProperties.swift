//
//  FortuneResultEntity+CoreDataProperties.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/03/01.
//
//

import Foundation
import CoreData


extension FortuneResultEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FortuneResultEntity> {
        return NSFetchRequest<FortuneResultEntity>(entityName: "FortuneResultEntity")
    }

    @NSManaged public var blood_type: String?
    @NSManaged public var capital: String?
    @NSManaged public var has_coast_line: Bool
    @NSManaged public var is_favorite: Bool
    @NSManaged public var logo_url: String?
    @NSManaged public var name: String?
    @NSManaged public var prefecture: String?
    @NSManaged public var today: Date?
    @NSManaged public var birthday: Date?
    @NSManaged public var uuid: UUID?
}

extension FortuneResultEntity : Identifiable {

}
