import SwiftUI


struct ContentView: View {
    var body: some View {
        TabView{
            PredictView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("占い")
                }
            HistoryView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("履歴")
                }
            PrefectureListView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("都道府県")
                }
            FavoriteView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("お気に入り")
                }
        }
    }
}


