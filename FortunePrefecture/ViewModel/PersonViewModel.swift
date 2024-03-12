//
//  PersonViewModel.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/03/04.
//

import Foundation
import CoreData

class PersonViewModel: ObservableObject {
    @Published var person: Person?
    @Published var people: [Person]?
    @Published var sortOption: SortOption = .fromNew
    
    enum SortOption {
        case fromNew, fromOld, byPrefecture
    }
    
    
    private let context: NSManagedObjectContext = PersistenceController.shared.context
    
    //特定のPersonオブジェクトなしで初期化際に使用
    init() {
        
    }
    
    init(person:Person){
        self.person = person
    }
    
    func sortPeople(sortOption: SortOption){
        self.sortOption = sortOption
        switch sortOption{
        case .byPrefecture:
            people = people?.sortedByPrefectureOrder()
        case .fromNew:
            people = people?.sorted(by: { $0.today > $1.today }) ?? []
        case .fromOld:
            people = people?.sorted(by: { $0.today < $1.today }) ?? []
        }
        
    }
    
    func addPerson() {
        guard let personDetail = self.person else {
            return
        }
        
        let fetchRequest: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", personDetail.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                let newPerson = PersonEntity(context: context)
                newPerson.id = personDetail.id
                newPerson.name = personDetail.name
                newPerson.birthday = personDetail.birthday
                newPerson.bloodType = personDetail.blood_type
                newPerson.today = personDetail.today
                newPerson.prefecture = addPrefecture(prefecture: personDetail.prefecture ?? Prefecture())
                
                try context.save()
            
            } else {
                return
            }
        } catch {
            return
        }
    }
    
    func deletePerson(person: Person) {
        
        let personId = person.id
        let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", personId.uuidString)
        request.fetchLimit = 1
        do {
            let results = try context.fetch(request)
            if let personEntity = results.first {
                   context.delete(personEntity)
            }
        } catch {
            return
        }
    }
    
    func fetchPerson(completion: @escaping (Result<Person, Error>) -> Void) {
        guard let personId = self.person?.id else {
            completion(.failure(NSError(domain: "NoPersonID", code: -1, userInfo: nil)))
            return
        }
        let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", personId.uuidString)
        request.fetchLimit = 1

        do {
            let results = try context.fetch(request)
            if let personEntity = results.first {
                let personModel = entityToModel(entity: personEntity)
                completion(.success(personModel))
            } else {
                completion(.failure(NSError(domain: "PersonNotFound", code: 404, userInfo: nil)))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchPeople(){
        let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            self.people = result.map { entity in
                entityToModel(entity: entity)
            }
            sortPeople(sortOption: sortOption)
        } catch {
            self.people = nil
        }
    }
    
    func fetchPeopleByPrefecture(prefecture: Prefecture){
        let prefectureEntity = fetchPrefectureByName(prefecture.name)
        let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        request.predicate = NSPredicate(format: "prefecture == %@", prefectureEntity!)
        
        do {
            let result = try context.fetch(request)
            self.people = result.map { entity in
                entityToModel(entity: entity)
            }
            
        } catch {
            self.people = nil
        }
    }
    
    func entityToModel(entity: PersonEntity) -> Person {
        return Person(id: entity.id ?? UUID(), name: entity.name ?? "", birthday: entity.birthday ?? Date(), bloodType: entity.bloodType ?? "", today: entity.today ?? Date(), prefecture: prefectureEntityToPrefecture(entity: entity.prefecture ?? PrefectureEntity()),isFavorite: entity.isFavorite
        )
    }
    
    func prefectureEntityToPrefecture(entity: PrefectureEntity) -> Prefecture {
        return Prefecture(id: entity.id ?? UUID(),
                          name: entity.name ?? "",
                          capital: entity.capital ?? "",
                          citizen_day: entity.citizenDayMonthDay,
                          has_coast_line: entity.hasCoastLine,
                          logo_url: entity.logoUrl ?? "",
                          brief: entity.brief ?? ""
        )
    }
    
    func addPrefecture(prefecture: Prefecture)-> PrefectureEntity? {
        let prefecrureEntity = fetchPrefectureByName(prefecture.name)
        if prefecrureEntity ==  nil{
            
            let newPrefecture = PrefectureEntity(context: context)
            newPrefecture.id = UUID()
            newPrefecture.name = prefecture.name
            newPrefecture.brief = prefecture.brief
            newPrefecture.hasCoastLine = prefecture.has_coast_line
            newPrefecture.citizenDay = prefecture.citizen_day?.toDate()
            newPrefecture.logoUrl = prefecture.logo_url
            newPrefecture.capital = prefecture.capital
            
            do {
                try context.save()
                return newPrefecture
            } catch {
                return nil
            }
        }else{
            return prefecrureEntity
        }
    }
    
    func fetchPrefectureByName(_ name: String) -> PrefectureEntity? {
        let request: NSFetchRequest<PrefectureEntity> = PrefectureEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            return nil
        }
    }

    func toggleFavorite() -> Bool? {
        guard let personId = self.person?.id else {
            return nil
        }
        let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", personId.uuidString)
        request.fetchLimit = 1

        do {
            let results = try context.fetch(request)
            if let personEntity = results.first {
                personEntity.isFavorite.toggle()
                try context.save()
                self.person!.is_favorite = personEntity.isFavorite
                return personEntity.isFavorite
            }
        } catch {
            return nil
        }

        return nil
    }
    
    func fetchFavorite() {
        let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
            
         do {
            let people = try context.fetch(request)
            self.people = people.map { entity in
                entityToModel(entity: entity)
            }
            sortPeople(sortOption: sortOption)
        } catch {
            self.people = nil
        }
    }

}
