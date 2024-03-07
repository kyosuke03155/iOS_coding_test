//
//  FetchFortune.swift
//  FortunePrefecture
//
//  Created by 石津恭介 on 2024/02/29.
//

import Foundation

/*

class FortuneViewModel: ObservableObject {
    let startDate: Date = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1)) ?? Date()
      
    @Published var name: String = ""
    @Published var birthday: Date = Date()
    @Published var bloodType: String = "a"
    @Published var result: String = "占い結果がここに表示されます"
    @Published var logoUrl: String = "" // 初期状態は空
    @Published var fortuneResponse: FortuneResponse
    let bloodTypes = ["A", "B", "O", "AB"]

    init() {
        
        self.fortuneResponse = FortuneResponse.preview
        
    }
    
    func fetchFortune() {
        let birthdayYmd = YearMonthDay(date: birthday)
        let todayYmd = YearMonthDay(date: Date())

        FortuneAPI.shared.fetchFortune(forName: name, birthday: birthdayYmd, bloodType: bloodType, today: todayYmd) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fortuneResponse):
                    self?.fortuneResponse = fortuneResponse
                    self?.result = "都道府県名: \(fortuneResponse.name)"
                    self?.logoUrl = fortuneResponse.logo_url
                case .failure(let error):
                    self?.result = "エラー: \(error.localizedDescription)"
                }
            }
        }
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
*/
/*
final class PrefectureFetcher {
    private let baseURL = "https://yumemi-ios-junior-engineer-codecheck.app.swift.cloud"
    private let endPoint = "/my_fortune"
    private let httpMethod = "POST"
    private let httpRequestHeaders = ["API-Version": "v1"]
        
    func fetchPrefectureData(person: Person) async throws -> Prefecture {
        guard let url = URL(string: baseURL + endPoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = httpRequestHeaders
        try request.httpBody = person.encodeToData()
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request)
            guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            return try data.decodeToPrefecture()
        }
    }
}

enum APIError: Error {
    case invalidURL
    case invalidRequest
    case invalidResponse
    case invalidEncode
    case invalidDecode
}
*/
