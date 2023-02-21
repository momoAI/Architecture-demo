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

class NewsPresenter {
    private let pageSize = 20
    private var page = 0
    private var itemList: Array<NewsCellPresenter> = [] {
        didSet {
            self.dataOnChanged?(())
        }
    }
    var isLoading: Bool = false {
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
    
    /// 添加新的数据 （如上拉加载更多）
    func append(newItems: [NewsCellPresenter]) {
        itemList.append(contentsOf: newItems)
    }
    
    func cellPresenter(at index: Int) -> NewsCellPresenter {
        return itemList[index]
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
                self.itemList = newsJsonArr.map { return NewsCellPresenter(item: News($0)) }
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
                let newDatas = newsJsonArr.map { return NewsCellPresenter(item: News($0)) }
                self.append(newItems: newDatas)
                self.page = self.page + 1
            case .failure(let err):
                self.dataOnError?(err)
            }
        }
    }
    
    
    // MARK: -本地存储
    // .....
    
}
