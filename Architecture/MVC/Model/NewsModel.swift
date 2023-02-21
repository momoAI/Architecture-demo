//
//  NewsModel.swift
//  Architecture
//
//  Created by fooww on 2023/2/15.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

typealias ChangedBlock<T> = (_ value: T) -> Void
//typealias ErrorBlock = (_ error: Error) -> Void

class NewsModel {
    private let pageSize = 20
    private var page = 0
    private var itemList: Array<News> = [] {
        didSet {
            self.dataOnChanged?(())
        }
    }
    private var isLoading: Bool = false {
        didSet {
            self.loadingChanged?(isLoading)
        }
    }
    
    var dataOnChanged: ChangedBlock<Void>?
    var dataOnError: ChangedBlock<Error>?
    var loadingChanged: ChangedBlock<Bool>?
    
    // MARK: -数据
    var count: Int {
        return itemList.count
    }
    
    func item(at index: Int) -> News {
        return itemList[index]
    }
    
    /// 添加新的数据 （如上拉加载更多）
    func append(newItems: [News]) {
        itemList.append(contentsOf: newItems)
    }
    
    func editData(at index: Int, newData: News) {
        itemList[index] = newData
    }
    
    // MARK: -网络
    func fetchAllDatas() {
        isLoading = true
        AF.request("https://c.3g.163.com/nc/article/list/T1467284926140/0-20.html").responseJSON { rsp in
            self.isLoading = false
            switch rsp.result {
            case .success(let json):
                let jsonData = JSON.init(json)
                let newsJsonArr = jsonData["T1467284926140"].arrayValue
                self.itemList = newsJsonArr.map { return News($0) }
            case .failure(let err):
                self.dataOnError?(err)
            }
        }
    }
    
    // 分页请求
    func fetchPartDatas() {
        isLoading = true
        AF.request("https://c.3g.163.com/nc/article/list/T1467284926140/\(page * pageSize)-\((page + 1) * pageSize).html").responseJSON { rsp in
            self.isLoading = false
            switch rsp.result {
            case .success(let json):
                let jsonData = JSON.init(json)
                let newsJsonArr = jsonData["T1467284926140"].arrayValue
                let newDatas = newsJsonArr.map { return News($0) }
                self.append(newItems: newDatas)
                self.page = self.page + 1
            case .failure(let err):
                self.dataOnError?(err)
            }
        }
    }
    
    func addReadCount(index: Int) {
        isLoading = true
        AF.request("https://www.baidu.com").response { rsp in
            self.isLoading = false
            switch rsp.result {
            case .success:
                var data = self.item(at: index)
                data.readCount += 1
                self.editData(at: index, newData: data)
            case .failure(let err):
                self.dataOnError?(err)
            }
        }
    }
    
//    func fetchAllDatas(callback: @escaping(_ success: Bool, _ errMsg: String) -> ()) {
//        // 这个请求 视情况可以再单独封装一层网络层
//        AF.request("https://c.3g.163.com/nc/article/list/T1467284926140/0-20.html").responseJSON { rsp in
//            var result = true
//            var msg = ""
//            switch rsp.result {
//            case .success(let json):
//                let jsonData = JSON.init(json)
//                let newsJsonArr = jsonData["T1467284926140"].arrayValue
//                self.itemList = newsJsonArr.map { return News($0) }
//            case .failure(let err):
//                result = false
//                msg = err.localizedDescription
//            }
//
//            callback(result, msg)
//        }
//    }
//
//    // 分页请求
//    func fetchPartDatas(callback: @escaping(_ success: Bool, _ errMsg: String) -> ()) {
//        AF.request("https://c.3g.163.com/nc/article/list/T1467284926140/\(page * pageSize)-\((page + 1) * pageSize).html").responseJSON { rsp in
//            var result = true
//            var msg = ""
//            switch rsp.result {
//            case .success(let json):
//                let jsonData = JSON.init(json)
//                let newsJsonArr = jsonData["T1467284926140"].arrayValue
//                let newDatas = newsJsonArr.map { return News($0) }
//                self.append(newItems: newDatas)
//                self.page = self.page + 1
//            case .failure(let err):
//                result = false
//                msg = err.localizedDescription
//            }
//
//            callback(result, msg)
//        }
//    }
    
    // MARK: -本地存储
    // .....
    
    // MARK: -弱业务
    func newsItemTitle(at index: Int) -> String {
        return self.item(at: index).title
    }
    
    func newsItemDate(at index: Int) -> String {
        let createTime = self.item(at: index).createTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: createTime)
        return dateFormatter.string(from: date ?? Date.now)
    }
    
    func newsItemCoverUrl(at index: Int) -> URL? {
        let urlSrc = self.item(at: index).coverSrc
        return URL(string: urlSrc.replacingOccurrences(of: "http:", with: "https:"))
    }
    
    func newsItemReadText(at index: Int) -> String {
        return "阅读:\(self.item(at: index).readCount)"
    }
}
