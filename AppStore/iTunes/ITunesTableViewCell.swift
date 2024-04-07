//
//  ITunesTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ITunesTableViewCell: UITableViewCell {
    //i 대문자 불편쓰..
    
    static let identifier = "ITunesTableViewCell"
    
    var disposeBag = DisposeBag()
    
    let appName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    let appIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()
    
    let downloadButton: UIButton = {
       let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = UIColor(named: "download")
        button.layer.cornerRadius = 15
        return button
    }()
    
    let starImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "star")
        return image
    }()
    
    let scoreLabel = DetailLabel()
    let devLabel = DetailLabel()
    let cateLabel = DetailLabel()
    
    let preView1 = AppImage()
    let preView2 = AppImage()
    let preView3 = AppImage()
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func configureHierarchy() {
        contentView.addSubview(appIcon)
        contentView.addSubview(appName)
        contentView.addSubview(downloadButton)
        
        contentView.addSubview(starImage)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(devLabel)
        contentView.addSubview(cateLabel)
        
        contentView.addSubview(preView1)
        contentView.addSubview(preView2)
        contentView.addSubview(preView3)
    }
    
    private func configureView(){
        appIcon.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.size.equalTo(60)
        }
        
        appName.snp.makeConstraints { make in
            make.top.equalTo(appIcon.snp.top).inset(10)
            make.leading.equalTo(appIcon.snp.trailing).offset(10)
            make.trailing.equalTo(downloadButton.snp.leading).inset(8)
            make.height.lessThanOrEqualTo(60)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(appIcon)
            make.width.equalTo(65)
            make.height.equalTo(30)
        }
        
        starImage.snp.makeConstraints { make in
            make.leading.equalTo(appIcon.snp.leading)
            make.top.equalTo(appIcon.snp.bottom).offset(8)
            make.size.equalTo(20)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(starImage.snp.top)
            make.leading.equalTo(starImage.snp.trailing).offset(4)
            make.height.equalTo(20)
            make.width.equalTo(70)
        }
        
        devLabel.snp.makeConstraints { make in
            make.top.equalTo(starImage.snp.top)
            make.height.equalTo(20)
            make.leading.equalTo(scoreLabel.snp.trailing)
            make.trailing.equalTo(cateLabel.snp.leading)

        }
        
        devLabel.textAlignment = .center

        cateLabel.snp.makeConstraints { make in
            make.top.equalTo(starImage.snp.top)
            make.height.equalTo(20)
            make.width.equalTo(100)
            make.trailing.equalToSuperview().inset(10)
        }
        
        cateLabel.textAlignment = .right
        
        preView1.snp.makeConstraints { make in
            make.top.equalTo(starImage.snp.bottom).offset(10)
            make.leading.equalTo(appIcon.snp.leading)
            make.width.equalTo((UIScreen.main.bounds.size.width - 40) / 3)
            make.bottom.equalToSuperview().inset(10)
        }
        
        preView2.snp.makeConstraints { make in
            make.top.equalTo(preView1.snp.top)
            make.leading.equalTo(preView1.snp.trailing).offset(10)
            make.width.equalTo((UIScreen.main.bounds.size.width - 40) / 3)
            make.bottom.equalTo(preView1.snp.bottom)
        }
        
        preView3.snp.makeConstraints { make in
            make.top.equalTo(preView1.snp.top)
            make.trailing.equalTo(downloadButton.snp.trailing)
            make.width.equalTo((UIScreen.main.bounds.size.width - 40) / 3)
            make.bottom.equalTo(preView1.snp.bottom)
        }

    }
}
