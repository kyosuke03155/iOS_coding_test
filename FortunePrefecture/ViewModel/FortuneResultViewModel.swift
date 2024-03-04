//
//  FortuneResultViewModel.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/03/01.
//

import SwiftUI
import CoreData

final class FortuneResultViewModel: ObservableObject {
    @Published var fortuneResults: [FortuneResult]?
    static let shared = FortuneResultViewModel()
    
    init(){
        
    }
    
    
    // 特定の条件に基づいてFortuneResultEntityのリストを取得し、それをFortuneResultの配列に変換して返す
    func fetchFortuneResults(context: NSManagedObjectContext) {
        let request: NSFetchRequest<FortuneResultEntity> = FortuneResultEntity.fetchRequest()
        // 必要に応じてフェッチリクエストに条件を追加
        // 例: request.predicate = NSPredicate(format: "条件")
        
        do {
            let resultEntities = try context.fetch(request)
            // Entityの配列をFortuneResultの配列に変換
            self.fortuneResults = resultEntities.map { entity in
                createFortuneResult(from: entity)
            }
        } catch {
            print("フェッチリクエスト失敗: \(error)")
            self.fortuneResults = nil
        }
    }
    
    func fetchFavoriteResults(context: NSManagedObjectContext) {
        let request: NSFetchRequest<FortuneResultEntity> = FortuneResultEntity.fetchRequest()
        request.predicate = NSPredicate(format: "is_favorite == %@", NSNumber(value: true))
            
        // 必要に応じてフェッチリクエストに条件を追加
        // 例: request.predicate = NSPredicate(format: "条件")
        
        do {
            let resultEntities = try context.fetch(request)
            // Entityの配列をFortuneResultの配列に変換
            self.fortuneResults = resultEntities.map { entity in
                createFortuneResult(from: entity)
            }
        } catch {
            print("フェッチリクエスト失敗: \(error)")
            self.fortuneResults = nil
        }
    }
    
    func createFortuneResultEntity(from fortuneResult: FortuneResult, in context: NSManagedObjectContext) -> FortuneResultEntity {
        let entity = FortuneResultEntity(context: context)
        entity.uuid = fortuneResult.id
        entity.name = fortuneResult.user_name
        entity.blood_type = fortuneResult.blood_type
        entity.capital = fortuneResult.capital
        entity.has_coast_line = fortuneResult.has_coast_line
        entity.logo_url = fortuneResult.logo_url
        entity.prefecture = fortuneResult.prefecture
        entity.is_favorite = fortuneResult.is_favorite
        entity.today = fortuneResult.today.toDate()
        entity.birthday = fortuneResult.birthday.toDate()
        
        return entity
    }
    
    func createFortuneResult(from entity: FortuneResultEntity) -> FortuneResult {
        // オプショナルプロパティに対してはデフォルト値を提供
        let name = entity.name ?? "不明"
        let bloodType = entity.blood_type ?? "不明"
        let capital = entity.capital ?? "不明"
        let logoURL = entity.logo_url ?? ""
        let prefecture = entity.prefecture ?? "不明"
        let todayDate = entity.today ?? Date()
        let birthdayDate = entity.birthday ?? Date()

        let today = YearMonthDay(date: todayDate)
        let birthday = YearMonthDay(date: birthdayDate)
        let uuid = entity.uuid ?? UUID()

        return FortuneResult(
            id: uuid,
            user_name: name,
            birthday: birthday,
            blood_type: bloodType,
            today: today,
            prefecture: prefecture,
            capital: capital,
            has_coast_line: entity.has_coast_line,
            logo_url: logoURL,
            brief: "", // FortuneResponseEntityにbriefがないため空文字列を使用
            is_favorite: entity.is_favorite
        )
    }
    
    func addFortuneResult(request: FortuneRequest, response: FortuneResponse, context: NSManagedObjectContext) {
        // 新しいFortuneResultEntityインスタンスを作成
        let newFortuneResultEntity = FortuneResultEntity(context: context)
        
        newFortuneResultEntity.uuid = UUID()
        // FortuneRequestからのデータを割り当て
        newFortuneResultEntity.name = request.name
        // Date型への変換が必要な場合は、YearMonthDayからDateへの変換を行う
        newFortuneResultEntity.birthday = request.birthday.toDate()
        newFortuneResultEntity.blood_type = request.blood_type
        newFortuneResultEntity.today = request.today.toDate()
        
        // FortuneResponseからのデータを割り当て
        newFortuneResultEntity.prefecture = response.name
        newFortuneResultEntity.capital = response.capital
        newFortuneResultEntity.has_coast_line = response.has_coast_line
        newFortuneResultEntity.logo_url = response.logo_url
        newFortuneResultEntity.is_favorite = false // 初期値としてfalseを設定
        // response.briefがあれば割り当てる、なければ適切なデフォルト値を使用
        
        // コンテキストに変更を保存して永続化
        do {
            try context.save()
            print("新しいFortuneResultEntityが正常に追加されました。")
        } catch {
            print("FortuneResultEntityの保存に失敗しました: \(error)")
        }
    }

    func getResultHistoty(context: NSManagedObjectContext) -> FortuneResultEntity?{
        let request = NSFetchRequest<FortuneResultEntity>(entityName: "FortuneResultEntity")
        
        // 条件がある場合は、ここにNSPredicateを設定する
        // 例: request.predicate = NSPredicate(format: "attributeName == %@", attributeValue)
        
        // エラーハンドリングを行いながらフェッチリクエストを実行
        do {
            let results = try context.fetch(request)
            
            // 最初の結果を返す（結果がない場合はnilを返す）
            return results.first
        } catch let error as NSError {
            // エラー処理（エラーログを出力するなど）
            print("フェッチリクエスト失敗: \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func toggleFavorite(fortuneResult: FortuneResultEntity, context: NSManagedObjectContext) -> Bool {
        let originalState = fortuneResult.is_favorite // 元の状態を保存
        fortuneResult.is_favorite.toggle() // is_favoriteをtrueに設定
        
        do {
            try context.save()
            return true
        } catch {
            print("お気に入りの状態の保存に失敗しました: \(error)")
            fortuneResult.is_favorite = originalState
            return false
        }
    }
}
