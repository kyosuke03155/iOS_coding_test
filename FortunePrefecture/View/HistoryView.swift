//
//  HistoryView.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/02/29.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel = FortuneResultViewModel.shared
    
    // Core DataからFortuneResponseEntityのフェッチリクエストを作成
    /*@FetchRequest(
     entity: FortuneResultEntity.entity(),
     sortDescriptors: [],
     predicate: NSPredicate(format: "is_favorite == %@", NSNumber(value: true))
     ) var fortuneList: FetchedResults<FortuneResultEntity>
     */
    var body: some View {
        List {
                ForEach(viewModel.fortuneResults ?? []) { fortuneResult in
                    HStack {
                        Text(fortuneResult.prefecture ?? "不明な都道府県")
                    
                        
                            AsyncImage(url: URL(string: fortuneResult.logo_url)) { phase in
                                switch phase {
                                case .empty:
                                    // 画像が読み込まれていない間に表示するビュー
                                    ProgressView()
                                case .success(let image):
                                    // 読み込み成功時に画像を表示
                                    image.resizable().aspectRatio(contentMode: .fit)
                                case .failure:
                                    // 読み込み失敗時に表示するビュー
                                    Image(systemName: "exclamationmark.circle")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                            .padding(.top)
                        
                    }
                }
                .onDelete(perform: deleteItem)
            }
            .onAppear {
                viewModel.fetchFavoriteResults(context: viewContext)
            }
    }
}

func deleteItem(at offsets: IndexSet) {
    print("jj")
    // ここに項目を削除するロジックを実装します。
    // 例えば、viewModel.fortuneResultsから特定の項目を削除する場合:
    // viewModel.fortuneResults?.remove(atOffsets: offsets)
}

#Preview {
    HistoryView()
}
