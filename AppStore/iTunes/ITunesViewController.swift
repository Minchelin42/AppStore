//
//  ITunesViewController.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher
import Toast

final class ITunesViewController: UIViewController {

    let tableView = UITableView()
    let searchBar = UISearchBar()
    
    let viewModel = ITunesViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        bind()
    }
    
    private func configure() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rx.title.onNext("검색")
        
        view.addSubview(UIView(frame: .zero))
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
        tableView.register(ITunesTableViewCell.self, forCellReuseIdentifier: ITunesTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 300
        
        searchBar.searchBarStyle = .minimal
        searchBar.rx.placeholder.onNext("게임, 앱, 스토리 등")
        
        
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        
        let selectedApp = PublishSubject<ITunesResult>()
        
        let input = ITunesViewModel.Input(searchButtonClicked: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text, selectedApp: selectedApp)
        
        let output = viewModel.transform(input: input)
        
        output.result
            .bind(to: tableView.rx.items(
                    cellIdentifier: ITunesTableViewCell.identifier,
                    cellType: ITunesTableViewCell.self)
            ) {(row, element, cell) in
                cell.appName.text = element.trackName
                cell.appIcon.kf.setImage(with: URL(string: element.artworkUrl512))
                cell.scoreLabel.text = String(format: "%.1f", element.averageUserRating)
                cell.devLabel.text = element.sellerName
                cell.cateLabel.text = element.genres[0]
                cell.preView1.kf.setImage(with: URL(string: element.screenshotUrls[0]), placeholder: UIImage(systemName: "suit.heart"))
                cell.preView2.kf.setImage(with: URL(string: element.screenshotUrls[1]), placeholder: UIImage(systemName: "suit.heart"))
                cell.preView3.kf.setImage(with: URL(string: element.screenshotUrls[2]), placeholder: UIImage(systemName: "suit.heart"))
                
                cell.downloadButton.rx.tap
                    .subscribe(onNext: { _ in
                        //Realm에 저장해야함
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.toastMessage
            .bind(with: self) { owner, _ in
                var style = ToastStyle()
                style.messageColor = .white
                style.backgroundColor = .darkGray
                style.messageFont = .systemFont(ofSize: 14, weight: .semibold)
                DispatchQueue.main.async {
                    owner.view.makeToast("네트워크 오류입니다", duration: 1.0, position: .bottom, style: style)
                }
            }
            .disposed(by: disposeBag)
        
        //이거 수정해야함^^
        Observable.zip(
            tableView.rx.modelSelected(ITunesResult.self),
            tableView.rx.itemSelected
        )
        .map { $0.0 }
            .subscribe(with: self) { owner, value in
                selectedApp.onNext(value)
            }
            .disposed(by: disposeBag)
        
        output.selectedApp
            .bind(with: self) { owner, value in
                let vc = AppDetailViewController()
                vc.selectedApp = value
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
    }

}

