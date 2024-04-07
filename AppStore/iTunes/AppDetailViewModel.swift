//
//  AppDetailViewModel.swift
//  AppStore
//
//  Created by 민지은 on 2024/04/07.
//

import Foundation
import RxSwift
import RxCocoa

class AppDetailViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let selectedApp: PublishSubject<ITunesResult>
    }
    
    struct Output {
        let selectedApp: PublishSubject<ITunesResult>
        let version: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        let selectedApp = PublishSubject<ITunesResult>()
        let version = PublishSubject<String>()
        
        input.selectedApp
            .subscribe(with: self) { owner, value in
                
                print("🩷🩷🩷🩷🩷🩷")
                print(value)
                selectedApp.onNext(value)
                version.onNext("버전 \(value.version)")
            }
            .disposed(by: disposeBag)
        
        
        return Output(selectedApp: selectedApp, version: version)
    }
    
}
