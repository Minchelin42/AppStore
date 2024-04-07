//
//  ITunes.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/07.
//

import Foundation

struct ITunes: Decodable {
    let results: [ITunesResult]
}

struct ITunesResult: Decodable {
    let trackName: String //앱 이름
    let averageUserRating: Double //평점
    let sellerName: String //개발자 이름
    let genres: [String] //카테고리
    let artworkUrl512: String //앱 아이콘
    let screenshotUrls: [String] //스크린샷
}
