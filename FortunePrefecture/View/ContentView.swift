import SwiftUI
import CoreData

struct ContentView: View {
    
    
    var body: some View {
        TabView {
            FirstView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("占い")
                }
            HistoryView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("履歴")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("お気に入り")
                }
        }
    }
}


