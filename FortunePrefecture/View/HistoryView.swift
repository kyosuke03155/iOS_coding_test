//
//  HistoryView.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/02/29.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    @StateObject var viewModel = PersonViewModel()
    @State private var sortOption: SortOption = .fromNew
    
    enum SortOption {
        case fromNew, fromOld, byPrefecture
    }
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.people ?? []) {person in
                    NavigationLink(destination: FortuneDetailView(personVM: PersonViewModel(person:person))) {
                        HStack {
                            VStack{
                                Text(person.todayString)
                                Text(person.name)
                            }
                            Spacer()
                            AsyncImage(url: URL(string: person.prefecture?.logo_url ?? "")) { image in
                                image.resizable().aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 60, height: 40)
                            .cornerRadius(10)
                            
                        }
                    }
                }
                .onDelete(perform: deletePerson)
            }
            .navigationTitle("占い履歴")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { viewModel.sortPeople(sortOption: .fromNew) }) {
                            Label("新しい順", systemImage: viewModel.sortOption == .fromNew ? "checkmark" : "")
                        }
                        Button(action: { viewModel.sortPeople(sortOption: .fromOld) }) {
                            Label("古い順", systemImage: viewModel.sortOption == .fromOld ? "checkmark" : "")
                        }
                        Button(action: { viewModel.sortPeople(sortOption: .byPrefecture) }) {
                            Label("都道府県順", systemImage: viewModel.sortOption == .byPrefecture ? "checkmark" : "")
                        }
                    } label: {
                        Label("並び替え", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .onAppear {
                viewModel.fetchPeople()
            }
        }
    }
    private func deletePerson(at offsets: IndexSet) {
        for index in offsets {
            guard let personToDelete = viewModel.people?[index] else {
                return }
            viewModel.deletePerson(person: personToDelete)
        }
        //データの再フェッチ
        viewModel.fetchPeople()
    }
}



