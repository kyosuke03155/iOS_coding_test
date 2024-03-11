import SwiftUI
import CoreData

struct ContentView: View {
    @State var selection = 1
    
    
    var body: some View {
        TabView(selection: $selection) {
            PredictView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("占い")
                }
                .tag(1)
            HistoryView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("履歴")
                }
                .tag(2)
            PrefectureListView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("都道府県")
                }
                .tag(3)
            FavoriteView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("お気に入り")
                }
                .tag(4)
        }
        .onChange(of: selection) {
                    if selection == 1 {
                        print("ホームタブが選択された")
                        // ここでホームタブが選択された時の処理を実装する
                    } else {
                        print("お知らせタブが選択された")
                        // ここでお知らせタブが選択された時の処理を実装する
                    }
                }
    }
}


