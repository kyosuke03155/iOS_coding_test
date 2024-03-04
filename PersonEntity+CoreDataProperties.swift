//
//  PersonEntity+CoreDataProperties.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/03/04.
//
//

import Foundation
import CoreData


extension PersonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonEntity> {
        return NSFetchRequest<PersonEntity>(entityName: "PersonEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var birthday: Date?
    @NSManaged public var bloodType: String?
    @NSManaged public var today: Date?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var prefecture: PrefectureEntity?

}

extension PersonEntity : Identifiable {

}
