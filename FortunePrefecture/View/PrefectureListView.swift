//
//  HistoryView.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/02/29.
//

import SwiftUI
import CoreData

struct PrefectureListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel2 = PrefectureViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel2.prefectures ?? []) {prefecture in
                    NavigationLink(destination: PrefectureDetailView(prefectureVM: PrefectureViewModel(prefecture:prefecture))) {
                        HStack {
                            Text(prefecture.name ?? "不明な都道府県")
                            Spacer()
                            
                            AsyncImage(url: URL(string: prefecture.logo_url)) { phase in
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
                }
            }
            .navigationTitle("都道府県コレクション")
            .onAppear {
                viewModel2.fetchAllPrefectures()
            }
        }
    }
}
