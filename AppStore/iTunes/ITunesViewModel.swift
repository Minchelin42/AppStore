//
//  ITunesViewModel.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ITunesViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        //검색 버튼 클릭
        let searchButtonClicked: ControlEvent<Void>
        //검색어
        let searchText: ControlProperty<String?>
    }
    
    struct Output {
        let result: PublishSubject<[ITunesResult]>
    }
    
    func transform(input: Input) -> Output {
        
        let iTunesList = PublishSubject<[ITunesResult]>()
        
        input.searchButtonClicked
            .withLatestFrom(input.searchText.orEmpty)
            .distinctUntilChanged()
            .flatMap {
                ITunesAPI.fetchITunesData(title: $0)
            }
            .subscribe(with: self, onNext: { owner, value in
                print("Transfrom Next")
                let result = value.results
                iTunesList.onNext(result)
            }, onError: { _,_ in
                print("Transform Error")
            }, onCompleted: { _ in
                print("Transform Completed")
            }, onDisposed: { _ in
                print("Transform Disposed")
            })
            .disposed(by: disposeBag)
        
        return Output(result: iTunesList)
    }
    
}
