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
    
    var citizenDayMonthDay: MonthDay? {
            get {
                guard let citizenDay = citizenDay else { return nil }
                return MonthDay(date: citizenDay)
            }
            set {
                guard let newValue = newValue else {
                    citizenDay = nil
                    return
                }
                let calendar = Calendar.current
                if let date = calendar.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: newValue.month, day: newValue.day)) {
                    citizenDay = date
                }
            }
        }
    
}

extension PrefectureEntity : Identifiable {

}
