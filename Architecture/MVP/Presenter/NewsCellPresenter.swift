//
//  NewsCellPresenter.swift
//  Architecture
//
//  Created by fooww on 2023/2/21.
//

import Foundation
import Alamofire

// 通过代理 presenter通知cell更新
protocol NewsCellPresenterProtocol: AnyObject {
    func updateReadCount(presenter: NewsCellPresenter)
}

class NewsCellPresenter {
    weak var cell: NewsCellPresenterProtocol?
    
    private(set) var newsItem = News()
    
    convenience init(item: News) {
        self.init()
        newsItem = item
    }
    
    // MARK: -弱业务
    func newsItemTitle() -> String {
        return self.newsItem.title
    }
    
    func newsItemDate() -> String {
        let createTime = self.newsItem.createTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: createTime)
        return dateFormatter.string(from: date ?? Date.now)
    }
    
    func newsItemCoverUrl() -> URL? {
        let urlSrc = self.newsItem.coverSrc
        return URL(string: urlSrc.replacingOccurrences(of: "http:", with: "https:"))
    }
    
    func newsItemReadText() -> String {
        return "阅读:\(self.newsItem.readCount)"
    }
    
    // MARK: -网络
    func addReadCount(callback: @escaping(_ success: Bool, _ errMsg: String) -> Void) {
        AF.request("https://www.baidu.com").response { rsp in
            var success = true
            var msg = ""
            switch rsp.result {
            case .success:
                self.newsItem.readCount += 1
                self.cell?.updateReadCount(presenter: self)
            case .failure(let err):
                success = false
                msg = err.localizedDescription
            }
            
            callback(success, msg)
        }
    }
}
