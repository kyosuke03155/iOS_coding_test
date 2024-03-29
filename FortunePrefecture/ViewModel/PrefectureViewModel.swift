//
//  PrefectureViewModel.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/03/04.
//

import Foundation
import CoreData

final class PrefectureViewModel: ObservableObject {
    @Published var prefectures: [Prefecture]?
    @Published var prefecture: Prefecture?
    @Published var sortOption: SortOption = .byPrefecture
    
    
    private let context: NSManagedObjectContext = PersistenceController.shared.context
    
    enum SortOption {
        case byPrefecture, byPrefectureDesc, peopleCount
    }
    
    init() {
        
    }
    
    func sortPrefecture(sortOption: SortOption){
        self.sortOption = sortOption
        self.fetchAllPrefectures()
    }
    
    init(prefecture:Prefecture){
        self.prefecture = prefecture
    }
    
    func addPrefecture()-> PrefectureEntity? {
        if (self.prefecture == nil){
            return nil
        }
        let prefecrureEntity = fetchPrefectureByName(self.prefecture!.name)
        if prefecrureEntity ==  nil{
            let newPrefecture = PrefectureEntity(context: context)
            newPrefecture.id = UUID()
            newPrefecture.name = self.prefecture?.name
            newPrefecture.brief = self.prefecture?.brief
            newPrefecture.hasCoastLine = self.prefecture?.has_coast_line ?? false
            newPrefecture.citizenDay = self.prefecture?.citizen_day?.toDate()
            newPrefecture.logoUrl = self.prefecture?.logo_url
            newPrefecture.capital = self.prefecture?.capital
            
            do {
                try context.save()
                return newPrefecture
            } catch {
                return nil
            }
        }
        else{
            return prefecrureEntity
        }
    }
    
    // すべての都道府県を取得するメソッド
    func fetchAllPrefectures(){
        let request: NSFetchRequest<PrefectureEntity> = PrefectureEntity.fetchRequest()
        //let sortDescriptor = NSSortDescriptor(key: "people.count", ascending: false)
        //request.sortDescriptors = [sortDescriptor]
        
        do {
            var prefectures = try context.fetch(request)
            if (sortOption == .peopleCount){
                prefectures = prefectures.sorted{
                    let count1 = $0.people?.count ?? 0
                    let count2 = $1.people?.count ?? 0
                    if count1 == count2 {
                        return PrefectureOrder.getOrder(of: $0.name ?? "")  < PrefectureOrder.getOrder(of: $1.name ?? "")
                    }
                    return count1 > count2
                }
            }
            self.prefectures = prefectures.map { entity in
                entityToModel(entity: entity)
            }
            if(sortOption == .byPrefecture){
                self.prefectures = self.prefectures?.sortedByPrefectureOrder()
            }else if(sortOption == .byPrefectureDesc){
                self.prefectures = self.prefectures?.sortedByPrefectureOrder().reversed()
            }
        } catch {
            self.prefectures = nil
        }
    }
    
    func addPrefecture2(prefecture: Prefecture)-> PrefectureEntity? {
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
    
    
    
    func entityToModel(entity: PrefectureEntity) -> Prefecture {
        return Prefecture(id: entity.id ?? UUID(),
                          name: entity.name ?? "",
                          capital: entity.capital ?? "",
                          citizen_day: entity.citizenDayMonthDay,
                          has_coast_line: entity.hasCoastLine,
                          logo_url: entity.logoUrl ?? "",
                          brief: entity.brief ?? ""
        )
    }
    
}
