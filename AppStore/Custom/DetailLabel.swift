//
//  DetailLabel.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/06.
//

import UIKit

class DetailLabel: UILabel {
    
    init() {
        super.init(frame: .zero)

        textColor = .lightGray
        font = .systemFont(ofSize: 13, weight: .medium)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
