//
//  PrefectureDetailView.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/03/04.
//

import SwiftUI
import CoreData


struct PrefectureDetailView: View {
    let prefecture: Prefecture = Prefecture()
    @State var isFavorite: Bool = false
    @State var pre:  String = ""
    @StateObject private var viewModel = FortuneResultViewModel()
    @StateObject private var prefectureVM = PrefectureViewModel()
    
    init(prefecture: Prefecture) {
        self.prefectureVM.prefecture = self.prefecture
        self.prefectureVM.addPrefecture2()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                AsyncImage(url: URL(string: prefecture.logo_url)) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 200)
                .cornerRadius(10)
                .padding(.top)
                
                Text(prefecture.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("県庁所在地: \(prefecture.capital)")
                    .font(.headline)
                
                Text("県庁所在地: \(pre)")
                    .font(.headline)
                
                HStack{
                    if prefecture.has_coast_line{
                        
                        
                        Image(systemName: "water.waves") // 例えば「波」を表すアイコン
                            .foregroundColor(.blue)
                        Text("海岸線あり")
                    } else {
                        Image(systemName: "mountain.2") // 例えば「山」を表すアイコン
                            .foregroundColor(.green)
                        Text("海岸線なし")
                    }
                }
                
                Text(prefecture.brief)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle("\(prefecture.name)の詳細")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // ここに保存処理を実装します。
                    print("保存ボタンがタップされました。")
                    isFavorite = true
                    let context = PersistenceController.shared.container.viewContext
                    
                    // 新しいオブジェクトを作成してコンテキストに追加
                    let newObject = FortuneResultEntity(context: context)
                    newObject.uuid = UUID()
                    newObject.name = "Sample"
                    newObject.has_coast_line = true
                    newObject.today = Date()
                    newObject.blood_type = "A"
                    newObject.capital = "Tokyo"
                    //newObject.logo_url = URL(string: "https://example.com/logo.png")
                    newObject.logo_url = prefecture.logo_url
                    newObject.prefecture = prefecture.name
                    newObject.is_favorite = false
                    
                    // コンテキストに変更が加えられた場合、保存する
                    do {
                        try context.save()
                    } catch {
                        print("Save failed: \(error.localizedDescription)")
                    }
                    
                    let request: NSFetchRequest<FortuneResultEntity> = FortuneResultEntity.fetchRequest()
                    do {
                        let result = try context.fetch(request)
                        for object in result {
                            print(object)
                            pre = object.prefecture ?? ""
                        }
                        
                        
                    } catch {
                        print("Fetch failed: \(error.localizedDescription)")
                        
                    }
                    viewModel.toggleFavorite(fortuneResult: newObject, context: context)
                    
                }) {
                    isFavorite ? Image(systemName: "heart.fill") : Image(systemName: "heart")
                }
            }
        }
    }
}
