//
//  NewsCellViewModel.swift
//  Architecture
//
//  Created by fooww on 2023/2/21.
//

import Foundation
import Alamofire

typealias ValueBinder<T> = (_ value: T) -> Void

class NewsCellViewModel {
    // 通过属性观测器 绑定
    var title = "" {
        didSet {
            
        }
    }
    var createTime = "" {
        didSet {
            
        }
    }
    var coverSrc = "" {
        didSet {
            
        }
    }
    var readCount = 0 {
        didSet {
            self.readCountBind?(newsItemReadText())
        }
    }
    
    // bind回调
    var readCountBind: ValueBinder<String>?
    
    convenience init(item: News) {
        self.init()
        title = item.title
        createTime = item.createTime
        coverSrc = item.coverSrc
        readCount = item.readCount
    }
    
    // MARK: -弱业务
    func newsItemTitle() -> String {
        return self.title
    }
    
    func newsItemDate() -> String {
        let createTime = self.createTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: createTime)
        return dateFormatter.string(from: date ?? Date.now)
    }
    
    func newsItemCoverUrl() -> URL? {
        let urlSrc = self.coverSrc
        return URL(string: urlSrc.replacingOccurrences(of: "http:", with: "https:"))
    }
    
    func newsItemReadText() -> String {
        return "阅读:\(self.readCount)"
    }
    
    // MARK: -网络
    func addReadCount(callback: @escaping(_ success: Bool, _ errMsg: String) -> Void) {
        AF.request("https://www.baidu.com").response { rsp in
            var success = true
            var msg = ""
            switch rsp.result {
            case .success:
                self.readCount += 1
            case .failure(let err):
                success = false
                msg = err.localizedDescription
            }
            
            callback(success, msg)
        }
    }
}
