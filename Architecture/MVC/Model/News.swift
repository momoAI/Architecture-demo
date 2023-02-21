//
//  News.swift
//  Architecture
//
//  Created by fooww on 2023/2/10.
//

import Foundation
import SwiftyJSON

struct News {
    let title: String
    let createTime: String
    let coverSrc: String
    var readCount: Int
    
    init(_ jsonData: JSON) {
        title = jsonData["title"].stringValue
        createTime = jsonData["ptime"].stringValue
        coverSrc = jsonData["imgsrc"].stringValue
        readCount = jsonData["readcount"].intValue
    }
//    
//    var newsItemDate: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//        let date = dateFormatter.date(from: createTime)
//        return dateFormatter.string(from: date ?? Date.now)
//    }
//    
//    var newsItemCoverUrl: URL? {
//        return URL(string: coverSrc.replacingOccurrences(of: "http:", with: "https:"))
//    }
}
