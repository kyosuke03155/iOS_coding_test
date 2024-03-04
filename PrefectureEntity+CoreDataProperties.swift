//
//  PrefectureEntity+CoreDataProperties.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/03/04.
//
//

import Foundation
import CoreData


extension PrefectureEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PrefectureEntity> {
        return NSFetchRequest<PrefectureEntity>(entityName: "PrefectureEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var brief: String?
    @NSManaged public var hasCoastLine: Bool
    @NSManaged public var citizenDay: Date?
    @NSManaged public var logoUrl: String?
    @NSManaged public var capital: String?
    @NSManaged public var people: NSSet?

}

// MARK: Generated accessors for people
extension PrefectureEntity {

    @objc(addPeopleObject:)
    @NSManaged public func addToPeople(_ value: PersonEntity)

    @objc(removePeopleObject:)
    @NSManaged public func removeFromPeople(_ value: PersonEntity)

    @objc(addPeople:)
    @NSManaged public func addToPeople(_ values: NSSet)

    @objc(removePeople:)
    @NSManaged public func removeFromPeople(_ values: NSSet)

}

extension PrefectureEntity : Identifiable {

}
