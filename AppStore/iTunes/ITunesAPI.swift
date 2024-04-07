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
    
    static func fetchITunesData(title: String) -> Observable<ITunes> {
        return Observable<ITunes>.create { observer in

            guard let url = URL(string: "https://itunes.apple.com/search?term=\(title)&country=kr&entity=software") else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                print("DataTask Succeed")
                
                if let _ = error {
                    print("Error")
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    print("Response Error")
                    return
                }
                
                if let data = data,
                   let appData = try? JSONDecoder().decode(ITunes.self, from: data) {
                    print(appData)
                    observer.onNext(appData)
                } else {
                    print("응답은 왔으나 디코딩 실패")
                    observer.onError(APIError.unknownResponse)
                }
                
            }.resume()
            
            
            
            return Disposables.create()
        }
    }
}
