//
//  FortuneDetailView.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/03/04.
//

import SwiftUI
import CoreData


struct FortuneDetailView: View {
    
    @State var isFavorite: Bool = false
    @ObservedObject var personVM = PersonViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                Group {
                    Text("あなたの情報")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                    HStack {
                        Spacer()
                        VStack{
                            Text("占った日")
                                .bold()
                            Text("名前")
                                .bold()
                            Text("誕生日")
                                .bold()
                            Text("血液型")
                                .bold()
                        }
                        Spacer()
                        VStack{
                            Text(personVM.person?.todayString ?? "不明")
                            Text(personVM.person?.name ?? "不明")
                            Text(personVM.person?.birthdayString ?? "不明")
                            Text(personVM.person?.blood_type.uppercased() ?? "不明")
                        }
                        Spacer()
                    }
                    .padding([.top, .bottom], 5) // 上下のPaddingを5に設定して、要素間の間隔を狭くする
                    .frame(maxWidth: .infinity, alignment: .leading) // 幅を最大限にして、左揃え
                    .background(Color(.systemGray6)) // 背景色を設定
                    .cornerRadius(8) // 角丸設定
                    .padding(.horizontal) // 水平方向のPadding
                    
                }
                
                Divider()
            
                Group {
                    
                    Text("都道府県: \(personVM.person?.prefecture?.name ?? "不明")")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("県庁所在地: \(personVM.person?.prefecture?.capital ?? "不明")")
                        .font(.headline)
                    
                    
                    HStack {
                        Image(systemName: (personVM.person?.prefecture?.has_coast_line==true) ? "water.waves" : "mountain.2")
                            .foregroundColor((personVM.person?.prefecture?.has_coast_line==true) ? .blue : .green)
                        Text((personVM.person?.prefecture?.has_coast_line==true) ? "海岸線あり" : "海岸線なし")
                            .font(.headline)
                    }
                    Text("県民の日: \(personVM.person?.prefecture?.citizen_day?.toString() ?? "無し" )")
                        .font(.headline)
                    
                    AsyncImage(url: URL(string: personVM.person?.prefecture?.logo_url ?? "")) { image in
                        image.resizable().aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 300, height: 200)
                    .cornerRadius(10)
                    Text("説明: \(personVM.person?.prefecture?.brief ?? "不明")")
                        .font(.headline)
                    
                    
                }
                
            }
            .padding()
        }
        .navigationTitle("占い結果詳細")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    Button(action: {
                        // ここに削除の処理を記述
                        if personVM.person != nil {
                            personVM.person!.is_favorite = false
                            personVM.deletePerson(person: personVM.person!)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "trash")
                    }
                    Button(action: {
                        if let newFavoriteStatus = personVM.toggleFavorite() {
                            isFavorite = newFavoriteStatus
                           
                        }
                    }) {
                        isFavorite ? Image(systemName: "heart.fill") : Image(systemName: "heart")
                    }
                }
                
            }
        }
        .onAppear{
            personVM.fetchPerson{ result in
                if case .failure(_) = result {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            isFavorite = personVM.person?.is_favorite ?? false
        }
    }
}
