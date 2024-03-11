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
    @StateObject var viewModel = PersonViewModel()
    @StateObject var personVM = PersonViewModel()
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.people ?? []) {person in
                    NavigationLink(destination: FortuneDetailView(personVM: PersonViewModel(person:person))) {
                        HStack {
                            VStack{
                                //Text(String(person.today) ?? "")
                                Text(person.name ??  "")
                            }
                            Text(person.prefecture?.name ?? "不明な都道府県")
                            Spacer()
                            AsyncImage(url: URL(string: person.prefecture?.logo_url ?? "")) { image in
                                image.resizable().aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 60, height: 40)
                            .cornerRadius(10)
                            // Text(person.id.uuidString ?? "")
                        }
                    }
                }
                .onDelete(perform: deletePerson)
            }
            .navigationTitle("占い履歴")
            .onAppear {
                viewModel.fetchPeople()
            }
        }
    }
    private func deletePerson(at offsets: IndexSet) {
        
        for index in offsets {
            print(viewModel.people?[index].id)
            
            // 対象のPersonオブジェクトを取得
            guard let personToDelete = viewModel.people?[index] else { return }
            
            // Core DataのコンテキストからPersonオブジェクトを削除
            viewModel.deletePerson(person: personToDelete)
        }
        viewModel.fetchPeople() // データを再フェッチしてUIを更新
    }
}


