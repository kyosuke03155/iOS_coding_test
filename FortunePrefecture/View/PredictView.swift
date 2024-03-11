import SwiftUI
import CoreData


struct PredictView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = FortuneViewModel()
    @State private var name = ""
    @State private var birthday = Date()
    @State private var bloodType = "a"
    
    init() {
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) { // 要素間の間隔を統一
                    
                    Spacer()
                    TextField("名前を入力してください", text: $viewModel.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    DatePicker("生年月日を選択してください", selection: $viewModel.birthday, in: viewModel.startDate...Date(), displayedComponents: .date)
                        .padding(.horizontal)
                    
                    Picker("血液型を選択してください", selection: $viewModel.bloodType) {
                        ForEach(BloodTypes.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type.rawValue.lowercased())
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    HStack{
                        Button("リセット") {
                            print(viewModel.name)
                            viewModel.reset()
                            
                        }
                        .padding()
                        .buttonStyle(.borderedProminent) // ボタンのスタイルを強調
                        Button("占いを実行") {
                            if (viewModel.name == ""){
                                print("入力して")
                            }else{
                                //viewModel.fetchFortune(birthday: birthday, bloodType: bloodType)
                                viewModel.fetchFortune()
                            }
                            
                        }
                        .padding()
                        .buttonStyle(.borderedProminent) // ボタンのスタイルを強調
                    }
                    
                    if(viewModel.result != "占い結果がここに表示されます"){
                        
                        Text(viewModel.result)
                            .padding()
                        
                        if let url = URL(string: viewModel.logoUrl), !viewModel.logoUrl.isEmpty {
                            AsyncImage(url: url) { image in
                                image.resizable().aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 200, height: 200)
                            .padding()
                        }
                        
                        
                        NavigationLink(destination: FortuneDetailView(personVM: viewModel.personVM)) {
                            Text("詳細を見る")
                                .padding()
                                .background(Color.blue) // ナビゲーションリンクの背景色
                                .foregroundColor(.white) // ナビゲーションリンクのテキスト色
                                .cornerRadius(10) // 角の丸み
                        }
                    }
                    
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("都道府県占い")
            //.navigationBarTitleDisplayMode(.inline)
        }
    }
}



