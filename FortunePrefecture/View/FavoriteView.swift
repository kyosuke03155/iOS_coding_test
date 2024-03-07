//
//  HistoryView.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/02/29.
//

import SwiftUI
import CoreData

struct FavoriteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel = PersonViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.people ?? []) {fortuneResult in
                    NavigationLink(destination: FortuneDetailView(personVM: PersonViewModel(person:fortuneResult))) {
                        HStack {
                            Text(fortuneResult.prefecture?.name ?? "不明な都道府県")
                            Text(fortuneResult.id.uuidString ?? "")
                        }
                    }
                }
                
            }
            .navigationTitle("お気に入り")
            .onAppear {
                viewModel.fetchFavorite()
            }
        }
    }
}
