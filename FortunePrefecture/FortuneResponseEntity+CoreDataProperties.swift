//
//  FortuneResponseEntity+CoreDataProperties.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/02/29.
//
//

import Foundation
import CoreData


extension FortuneResponseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FortuneResponseEntity> {
        return NSFetchRequest<FortuneResponseEntity>(entityName: "FortuneResponseEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var has_coast_line: Bool
    @NSManaged public var today: Date?
    @NSManaged public var blood_type: String?
    @NSManaged public var capital: String?
    @NSManaged public var logo_url: String?
    @NSManaged public var prefecture: String?
    @NSManaged public var is_favorite: Bool

}

extension FortuneResponseEntity : Identifiable {

}
