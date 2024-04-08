//
//  ITunesAPI.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/07.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

class ITunesAPI {
    
    static func fetchITunesData(title: String) -> Single<ITunes> {
        return Single.create { single -> Disposable in
            //네트워크 통신 실패를 위해서 일부러 url 수정해놓음
            guard let url = URL(string: "https://111itunes.apple.com/search?term=\(title)&country=kr&entity=software") else {
                single(.failure(APIError.invalidURL))
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                print("DataTask Succeed")
                
                if let error = error {
                    print("Error")
                    single(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    print("Response Error")
                    return
                }
                
                if let data = data,
                   let appData = try? JSONDecoder().decode(ITunes.self, from: data) {
                    single(.success(appData))
                } else {
                    print("응답은 왔으나 디코딩 실패")
                    single(.failure(APIError.unknownResponse))
                }
                
            }.resume()
            
            return Disposables.create()
        }.debug("Observable iTunes")
    }
}
