//
//  AppImage.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/06.
//

import UIKit

class AppImage: UIImageView {
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .green
        contentMode = .scaleToFill
        clipsToBounds = true
        layer.cornerRadius = 12
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
