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

class ITunesViewController: UIViewController {

    let tableView = UITableView()
    let searchBar = UISearchBar()
    
    let viewModel = ITunesViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        bind()
    }
    
    func configure() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.isUserInteractionEnabled = false
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
    
    func bind() {
        
        let input = ITunesViewModel.Input(searchButtonClicked: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text)
        
        let output = viewModel.transform(input: input)
        
        output.result
            .bind(to: tableView.rx.items(
                    cellIdentifier: ITunesTableViewCell.identifier,
                    cellType: ITunesTableViewCell.self)
            ) { (row, element, cell) in
                cell.appName.text = element.trackName
                cell.appIcon.kf.setImage(with: URL(string: element.artworkUrl512))
                cell.scoreLabel.text = String(format: "%.1f", element.averageUserRating)
                cell.devLabel.text = element.sellerName
                cell.cateLabel.text = element.genres[0]
                cell.preView1.kf.setImage(with: URL(string: element.screenshotUrls[0]))
                cell.preView2.kf.setImage(with: URL(string: element.screenshotUrls[1]))
                cell.preView3.kf.setImage(with: URL(string: element.screenshotUrls[2]))
            }
            .disposed(by: disposeBag)
        
        
    }

}

