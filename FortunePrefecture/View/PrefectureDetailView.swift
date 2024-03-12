import SwiftUI

struct PrefectureDetailView: View {
    @ObservedObject var prefectureVM = PrefectureViewModel()
    @ObservedObject var personVM = PersonViewModel()
    
    var body: some View {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 10){
                        Text("都道府県: \(prefectureVM.prefecture?.name ?? "不明")")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("県庁所在地: \(prefectureVM.prefecture?.capital ?? "不明")")
                            .font(.headline)
                        
                        
                        HStack {
                            Image(systemName: (prefectureVM.prefecture?.has_coast_line==true) ? "water.waves" : "mountain.2")
                                .foregroundColor((prefectureVM.prefecture?.has_coast_line==true) ? .blue : .green)
                            Text((prefectureVM.prefecture?.has_coast_line==true) ? "海岸線あり" : "海岸線なし")
                                .font(.headline)
                        }
                        Text("県民の日: \(prefectureVM.prefecture?.citizen_day?.toString() ?? "無し" )")
                            .font(.headline)
                        
                        AsyncImage(url: URL(string: prefectureVM.prefecture?.logo_url ?? "")) { image in
                            image.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 300, height: 200)
                        .cornerRadius(10)
                        Text("説明: \(prefectureVM.prefecture?.brief ?? "不明")")
                            .font(.headline)
                    }
                    
                }
                Section {
                    // 占い結果のリスト
                    ForEach(personVM.people ?? []) { person in
                        NavigationLink(destination: FortuneDetailView(personVM: PersonViewModel(person: person))) {
                            HStack {
                                Text(person.todayString)
                                Text(person.name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("都道府県詳細")
            .onAppear {
                personVM.fetchPeopleByPrefecture(prefecture: prefectureVM.prefecture!)
            }
    }
}
