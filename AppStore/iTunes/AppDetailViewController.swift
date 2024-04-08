//
//  AppDetailViewController.swift
//  AppStore
//
//  Created by 민지은 on 2024/04/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher


final class AppDetailViewController: UIViewController {
    
    let appIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()
    
    let appName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    let devLabel = DetailLabel()
    
    let downloadButton: UIButton = {
       let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        return button
    }()
    
    let newsLabel = {
        let label = UILabel()
        label.text = "새로운 소식"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let versionLabel = DetailLabel()
    
    let updateLabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let detailLabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let disposeBag = DisposeBag()
    
    let viewModel = AppDetailViewModel()
    
    var selectedApp: ITunesResult? = nil
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        
        scrollView.bounces = false
        
        configureHierarchy()
        configureLayout()
        configureContentView()
        bind()
    }
    
    private func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func configureContentView() {
        
        contentView.addSubview(appIcon)
        contentView.addSubview(appName)
        contentView.addSubview(devLabel)
        contentView.addSubview(downloadButton)
        contentView.addSubview(newsLabel)
        contentView.addSubview(versionLabel)
        contentView.addSubview(updateLabel)
        contentView.addSubview(detailLabel)
        
        appIcon.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(10)
            make.size.equalTo(85)
        }
        
        appName.snp.makeConstraints { make in
            make.top.equalTo(appIcon.snp.top).inset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.leading.equalTo(appIcon.snp.trailing).offset(10)
            make.height.equalTo(20)
        }
        
        devLabel.snp.makeConstraints { make in
            make.leading.equalTo(appName.snp.leading)
            make.top.equalTo(appName.snp.bottom).offset(8)
            make.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(10)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.equalTo(appName.snp.leading)
            make.top.equalTo(devLabel.snp.bottom).offset(8)
            make.bottom.equalTo(appIcon.snp.bottom)
            make.width.equalTo(65)
        }
        
        newsLabel.snp.makeConstraints { make in
            make.leading.equalTo(appIcon.snp.leading).inset(4)
            make.top.equalTo(appIcon.snp.bottom).offset(20)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.leading.equalTo(newsLabel.snp.leading)
            make.top.equalTo(newsLabel.snp.bottom).offset(8)
            make.height.equalTo(10)
            make.width.equalTo(120)
        }
        
        updateLabel.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(contentView).inset(14)
            make.height.greaterThanOrEqualTo(50)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(updateLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(contentView).inset(14)
            make.bottom.equalTo(contentView).inset(10)
        }
    }
    
    private func bind() {
        guard let selectedApp = selectedApp else { return }

        let select = PublishSubject<ITunesResult>()
        
        let input = AppDetailViewModel.Input(selectedApp: select)
        var output = viewModel.transform(input: input)
        
        output.selectedApp
            .bind(with: self) { owner, value in
            owner.appIcon.kf.setImage(with: URL(string: value.artworkUrl512))
            owner.appName.text = value.trackName
                owner.devLabel.text = value.sellerName
                owner.updateLabel.text = value.releaseNotes
                owner.detailLabel.text = value.description
        }
        .disposed(by: disposeBag)
        
        output.version
            .bind(to: versionLabel.rx.text)
            .disposed(by: disposeBag)

        select.onNext(selectedApp)
        
    }
    
}

