//
//  FortuneViewModel.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/03/04.
//

import Foundation
import CoreData

class FortuneViewModel: ObservableObject {
    let startDate: Date = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1)) ?? Date()
    
    @Published var personVM: PersonViewModel
    @Published var prefectureVM: PrefectureViewModel
    @Published var name: String = ""
    @Published var birthday: Date = Date()
    @Published var bloodType: String = "a"
    @Published var result: String = "占い結果がここに表示されます"
    @Published var logoUrl: String = "" // 初期状態は空
    private var lastFetchedName: String?
    private var lastFetchedBirthday: Date?
    private var lastFetchedBloodType: String?
    
    //@Published var fortuneResponse: FortuneResponse
    
    private let context: NSManagedObjectContext = PersistenceController.shared.context
    let bloodTypes = ["A", "B", "O", "AB"]
    
    init() {
        self.personVM = PersonViewModel()
        self.prefectureVM = PrefectureViewModel()
        //self.fortuneResponse = FortuneResponse.preview
    }
    
    func reset(){
        name = ""
        birthday = Date()
        bloodType = "a"
        result = "占い結果がここに表示されます"
        logoUrl = ""
        self.personVM = PersonViewModel()
        self.prefectureVM = PrefectureViewModel()
    }
    
    
    //func fetchFortune(birthday: Date, bloodType: String) {
    func fetchFortune() {
        
        guard name != lastFetchedName || birthday != lastFetchedBirthday || bloodType != lastFetchedBloodType else {
            print("変更がありません")
            return
        }
        
        let today = Date()
        let todayYMD = YearMonthDay(date: today)
        let birthdayYMD = YearMonthDay(date: birthday)
        
        self.personVM.person = Person(name: name, birthday: birthday, bloodType: bloodType, today: today)
        
        
        print(name, birthday, bloodType,today)
        FortuneAPI.shared.fetchFortune(forName: self.name, birthday: birthdayYMD, bloodType: bloodType, today: todayYMD) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let prefecture):
                    
                    let _prefecture = Prefecture(name: prefecture.name, capital: prefecture.capital, citizen_day: prefecture.citizen_day, has_coast_line: prefecture.has_coast_line, logo_url: prefecture.logo_url, brief: prefecture.brief)
                    self?.prefectureVM.prefecture = _prefecture
                    self?.prefectureVM.addPrefecture()
                    self?.personVM.person?.prefecture = _prefecture
                    self?.personVM.addPerson()
                    self?.result = "都道府県名: \(prefecture.name)"
                    self?.logoUrl = prefecture.logo_url
                case .failure(let error):
                    self?.result = "エラー: \(error.localizedDescription)"
                }
            }
        }
        lastFetchedName = name
        lastFetchedBirthday = birthday
        lastFetchedBloodType = bloodType
    }
}


class FortuneAPI {
    static let shared = FortuneAPI()
    
    private let baseURL = "https://yumemi-ios-junior-engineer-codecheck.app.swift.cloud"
    private let endPoint = "/my_fortune"
    
    private init() {}
    
    func fetchFortune(forName name: String, birthday: YearMonthDay, bloodType: String, today: YearMonthDay, completion: @escaping (Result<FortuneResponse, Error>) -> Void) {
        guard let url = URL(string: baseURL + endPoint) else {
            completion(.failure(NSError(domain: "FortuneAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        print("mm")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("v1", forHTTPHeaderField: "API-Version")  // APIバージョンの指定
        
        let requestBody = FortuneRequest(name: name, birthday: birthday, blood_type: bloodType, today: today)
        
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
        } catch {
            
            completion(.failure(error))
            return
        }
        print("req")
        print(requestBody)
        print(name, birthday, bloodType,today)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "FortuneAPI", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(FortuneResponse.self, from: data)
                completion(.success(responseData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
