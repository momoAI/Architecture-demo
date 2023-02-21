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
    
    init() {
        title = ""
        createTime = "2000-01-01"
        coverSrc = ""
        readCount = 0
    }
    
    init(_ jsonData: JSON) {
        title = jsonData["title"].stringValue
        createTime = jsonData["ptime"].stringValue
        coverSrc = jsonData["imgsrc"].stringValue
        readCount = jsonData["readcount"].intValue
    }
}
