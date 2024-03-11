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
                ForEach(viewModel.people ?? []) {person in
                    NavigationLink(destination: FortuneDetailView(personVM: PersonViewModel(person:person))) {
                        HStack {
                            Text(person.prefecture?.name ?? "不明な都道府県")
                            Text(person.id.uuidString )
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
