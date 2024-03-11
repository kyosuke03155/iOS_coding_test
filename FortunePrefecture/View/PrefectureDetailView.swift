import SwiftUI

struct PrefectureDetailView: View {
    @ObservedObject var prefectureVM = PrefectureViewModel()
    @ObservedObject var personVM = PersonViewModel()
    
    var body: some View {
        //NavigationView {
            List {
                Section {
                    // 「あなたの情報」グループ
                    VStack(alignment: .leading, spacing: 5) {
                        Text("都道府県: \(prefectureVM.prefecture?.name ?? "不明")")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("県庁所在地: \(prefectureVM.prefecture?.capital ?? "不明")")
                            .font(.headline)
                        Text("県民の日: \(prefectureVM.prefecture?.citizen_day?.toString() ?? "無し" )")
                            .font(.headline)
                        Text((prefectureVM.prefecture?.has_coast_line == true) ? "海岸線あり" : "海岸線なし")
                        HStack {
                            Image(systemName: (prefectureVM.prefecture?.has_coast_line == true) ? "waveform.path.ecg" : "mountain")
                                .foregroundColor((prefectureVM.prefecture?.has_coast_line == true) ? .blue : .green)
                            Text((prefectureVM.prefecture?.has_coast_line == true) ? "海岸線あり" : "海岸線なし")
                        }
                    }
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
                
                Section {
                    // レスポンス情報の表示
                    AsyncImage(url: URL(string: prefectureVM.prefecture?.logo_url ?? "")) { image in
                        image.resizable().aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 300, height: 200)
                    .cornerRadius(10)
                }
                
                Section {
                    // 人々のリスト
                    ForEach(personVM.people ?? []) { person in
                        NavigationLink(destination: FortuneDetailView(personVM: PersonViewModel(person: person))) {
                            HStack {
                                Text("s")
                                Text(person.name ?? "県")
                            }
                        }
                    }
                }
            }
            .navigationTitle("結果詳細")
            .onAppear {
                personVM.fetchPeopleByPrefecture(prefecture: prefectureVM.prefecture!)
            }
        //}
    }
}
