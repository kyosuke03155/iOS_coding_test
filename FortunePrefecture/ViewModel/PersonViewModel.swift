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
    
    
    private let context: NSManagedObjectContext = PersistenceController.shared.context
    
    //特定のPersonオブジェクトなしで初期化際に使用
    init() {
        
    }
    
    init(person:Person){
        self.person = person
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
                // IDに一致するPersonEntityが存在しない場合、新しいエンティティを追加
                let newPerson = PersonEntity(context: context)
                newPerson.id = personDetail.id
                newPerson.name = personDetail.name
                newPerson.birthday = personDetail.birthday
                newPerson.bloodType = personDetail.blood_type
                newPerson.today = personDetail.today
                newPerson.prefecture = addPrefecture(prefecture: personDetail.prefecture ?? Prefecture())
                
                try context.save()
                print("Person saved successfully")
            } else {
                // IDに一致するPersonEntityが既に存在する場合は、既存のエンティティを更新するか、
                // 何もしないで終了することを選択できます。
                print("Person already exists. No new entity added.")
            }
        } catch {
            print("Failed to fetch or save person: \(error)")
        }
    }
    
    func deletePerson(person: Person) {
        print(#function)
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
                // データが見つかった場合
                let personModel = entityToModel(entity: personEntity)
                completion(.success(personModel))
            } else {
                // データが存在しない場合
                completion(.failure(NSError(domain: "PersonNotFound", code: 404, userInfo: nil)))
            }
        } catch {
            // 他のエラーが発生した場合
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
            self.people = people!.sorted { $0.today > $1.today }
        } catch {
            print("Failed to fetch prefectures: \(error)")
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
            print("Failed to fetch prefectures: \(error)")
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
                print("Prefecture saved successfully")
                return newPrefecture
            } catch {
                print("Failed to save prefecture: \(error)")
                return nil
            }
        }else{
            print("すでに存在する都道府県です")
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
            print("Failed to fetch prefectures by name: \(error)")
            return nil
        }
    }

    func toggleFavorite() -> Bool? {
        guard let personId = self.person?.id else {
            return nil // personがnilの場合、処理に失敗したことを示すためにnilを返す
        }
        let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", personId.uuidString)
        request.fetchLimit = 1

        do {
            let results = try context.fetch(request)
            if let personEntity = results.first {
                personEntity.isFavorite.toggle() // お気に入りの状態をトグル
                try context.save() // 変更を保存
                self.person!.is_favorite = personEntity.isFavorite
                print(self.person!.is_favorite)
                return personEntity.isFavorite // 新しいお気に入りの状態を返す
            }
        } catch {
            return nil // エラーが発生した場合、処理に失敗したことを示すためにnilを返す
        }

        return nil // 該当するPersonEntityが見つからなかった場合、処理に失敗したことを示すためにnilを返す
    }
    
    func fetchFavorite() {
        let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
            
         do {
            let people = try context.fetch(request)
            self.people = people.map { entity in
                entityToModel(entity: entity)
            }
        } catch {
            self.people = nil
        }
    }

}
