import SwiftUI
import CoreData


struct FirstView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = FortuneViewModel()
    @State private var name = ""
    @State private var birthday = Date()
    @State private var bloodType = "a"

    init() {
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("名前を入力してください", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                DatePicker("生年月日を選択してください", selection: $birthday, in: viewModel.startDate...Date(), displayedComponents: .date)
                    .padding()
                
                Picker("血液型を選択してください", selection: $bloodType) {
                    ForEach(BloodTypes.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type.rawValue.lowercased())
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button("占いを実行") {
                    viewModel.fetchFortune(name: name, birthday: birthday, bloodType: bloodType)
                }
                .padding()
                
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
                    Text("遷移")
                        .padding()
                }
            }
        }
    }
    
    
}



