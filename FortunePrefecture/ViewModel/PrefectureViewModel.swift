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
    
    private let context: NSManagedObjectContext = PersistenceController.shared.context
    
    init() {
        
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
                print("Prefecture saved successfully")
                return newPrefecture
            } catch {
                print("Failed to save prefecture: \(error)")
                return nil
            }
        }
        else{
            print("すでに存在する都道府県です")
            return prefecrureEntity
        }
    }
    
    // すべての都道府県を取得するメソッド
    func fetchAllPrefectures(){
        let request: NSFetchRequest<PrefectureEntity> = PrefectureEntity.fetchRequest()
        print("fetchPrefectureByName")
        do {
            let result = try context.fetch(request)
            self.prefectures = result.map { entity in
                entityToModel(entity: entity)
            }
        } catch {
            print("Failed to fetch prefectures: \(error)")
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
    
    // 特定の条件で都道府県を検索するメソッド（例: 名前による検索）
    func fetchPrefectureByName(_ name: String) -> PrefectureEntity? {
        let request: NSFetchRequest<PrefectureEntity> = PrefectureEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
        request.fetchLimit = 1 // 結果を1つに限定
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch prefectures by name: \(error)")
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
