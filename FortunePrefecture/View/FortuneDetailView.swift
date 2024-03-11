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
                    
                    VStack(alignment: .leading, spacing: 5) { // 要素間隔を5に設定
                        HStack {
                            Text("名前:")
                                .bold()
                            Spacer()
                            Text(personVM.person?.name ?? "不明")
                        }
                        
                        HStack {
                            Text("血液型:")
                                .bold()
                            Spacer()
                            Text(personVM.person?.blood_type.uppercased() ?? "不明")
                        }
                        Text("血液型:")
                            .bold()
                        //Text(personVM.person?.birthday.toString() ?? "不明")
                        Spacer()
                        
                    }
                    .padding([.top, .bottom], 5) // 上下のPaddingを5に設定して、要素間の間隔を狭くする
                    .frame(maxWidth: .infinity, alignment: .leading) // 幅を最大限にして、左揃え
                    .background(Color(.systemGray6)) // 背景色を設定
                    .cornerRadius(8) // 角丸設定
                    .padding(.horizontal) // 水平方向のPadding
                    
                    
                }
                
                Divider()
                //Text(personVM.person?.birthday.toString() ?? "不明")
                // レスポンス情報の表示
                Group {
                    
                    Text("都道府県: \(personVM.person?.prefecture?.name ?? "不明")")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("県庁所在地: \(personVM.person?.prefecture?.capital ?? "不明")")
                        .font(.headline)
                    
                    
                    
                    HStack {
                        Image(systemName: (personVM.person?.prefecture?.has_coast_line==true) ? "waveform.path.ecg" : "mountain")
                            .foregroundColor((personVM.person?.prefecture?.has_coast_line==true) ? .blue : .green)
                        Text((personVM.person?.prefecture?.has_coast_line==true) ? "海岸線あり" : "海岸線なし")
                    }
                    
                    AsyncImage(url: URL(string: personVM.person?.prefecture?.logo_url ?? "")) { image in
                        image.resizable().aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 300, height: 200)
                    .cornerRadius(10)
                    Text("説明: \(personVM.person?.prefecture?.brief ?? "不明")")
                        .font(.headline)
                    Text("県民の日: \(personVM.person?.prefecture?.citizen_day?.toString() ?? "無し" )")
                        .font(.headline)
                    
                }
                
            }
            .padding()
        }
        .navigationTitle("\(personVM.person?.name ?? "")さんの占い結果詳細")
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
                            print(personVM.person?.is_favorite)
                        } else {
                            // toggleFavorite が失敗した場合の処理
                            print("お気に入り状態の変更に失敗しました。")
                        }
                    }) {
                        isFavorite ? Image(systemName: "heart.fill") : Image(systemName: "heart")
                    }
                }
                
            }
        }
        .onAppear{
            //personVM.syncFavorite()
            personVM.fetchPerson{ result in
                switch result {
                case .success(_):
                    // 成功時の処理をここに書く。このケースでは何もしない。
                    break // 明示的に何もしないことを示す。
                case .failure(let error):
                    // エラー時の処理。エラーに応じた処理をここに書く。
                    print("Error fetching person: \(error.localizedDescription)")
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            isFavorite = personVM.person?.is_favorite ?? false
            print(isFavorite)
        }
    }
}
