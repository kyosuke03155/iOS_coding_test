import SwiftUI

struct PredictView: View {
    
    @StateObject private var viewModel = FortuneViewModel()
    @State private var isShowAlert = false
    @FocusState var keyboardFocus:Bool
    @State private var showDetailView = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    
                    Spacer()
                    Divider()
                    TextField("名前を入力してください", text: $viewModel.name)
                        .submitLabel(SubmitLabel.done)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .focused(self.$keyboardFocus)
                    Divider()
                    DatePicker("生年月日を選択してください", selection: $viewModel.birthday, in: viewModel.startDate...Date(), displayedComponents: .date)
                        .padding(.horizontal)
                    Divider()
                    Text("血液型を選択してください")
                        .padding(.horizontal)
                    Picker("血液型を選択してください", selection: $viewModel.bloodType) {
                        ForEach(BloodTypes.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type.rawValue.lowercased())
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .onChange(of: viewModel.bloodType) {
                        
                        keyboardFocus = false
                    }
                    Divider()
                    
                    HStack{
                        Button("リセット") {
                            viewModel.reset()
                            
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        
                        Button("占いを実行") {
                            keyboardFocus = false
                            if (viewModel.name == ""){
                                isShowAlert.toggle()
                            }else{
                                viewModel.fetchFortune()
                            }
                            
                        }
                        .font(.headline)
                        .padding()
                        .buttonStyle(.borderedProminent)
                    }
                    
                    
                    
                    
                    if(viewModel.result != ""){
                        
                        Text(viewModel.result)
                            .padding()
                        
                        if let url = URL(string: viewModel.logoUrl), !viewModel.logoUrl.isEmpty {
                            AsyncImage(url: url) { image in
                                image.resizable().aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 150, height: 150)
                            .padding()
                        }
                        Button(action: {
                        
                            viewModel.personVM.addPerson()
                            showDetailView = true
                        }) {
                            Text("詳細を見る")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .navigationDestination(isPresented: $showDetailView) {
                            FortuneDetailView(personVM: viewModel.personVM)
                                    }
                    }
                    
                }
                .padding(.bottom, 20)
                
            }
            .navigationTitle("都道府県占い")
        }
        .alert("名前を入力してください", isPresented: $isShowAlert) {
            
        } message: {
            
            Text("占いができません")
        }
    }
}


