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
        //선택된 앱
        let selectedApp: PublishSubject<ITunesResult>
    }
    
    struct Output {
        let result: PublishSubject<[ITunesResult]>
        let selectedApp: PublishSubject<ITunesResult>
        let toastMessage: PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let iTunesList = PublishSubject<[ITunesResult]>()
        let selectedApp = PublishSubject<ITunesResult>()
        let toastMessage = PublishSubject<Void>()
        
        input.searchButtonClicked
            .withLatestFrom(input.searchText.orEmpty)
            .distinctUntilChanged()
            .flatMap {
                ITunesAPI.fetchITunesData(title: $0)
                    .catch { error in
                        toastMessage.onNext(())
                        return Single<ITunes>.never()
                    }
            }
            .debug("flatMap")
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
        
        input.selectedApp
            .subscribe(with: self) { owner, value in
                selectedApp.onNext(value)
            }
            .disposed(by: disposeBag)
        
        return Output(result: iTunesList, selectedApp: selectedApp, toastMessage: toastMessage)
    }
    
}
