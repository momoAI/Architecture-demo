//
//  NesListViewController.swift
//  Architecture
//
//  Created by fooww on 2023/2/10.
//

import UIKit
import Kingfisher
import Alamofire
import ObjectMapper
import SwiftyJSON

class NewsListViewController: UIViewController {
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        return indicator
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .lightGray
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    let cellId = "newsCellId"
    var newsList = Array<News>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        AF.request("https://c.3g.163.com/nc/article/list/T1467284926140/0-20.html").responseJSON { rsp in
            self.activityIndicator.stopAnimating()

            switch rsp.result {
            case .success(let json):
                print(json)
                let jsonData = JSON.init(json)
                let newsJsonArr = jsonData["T1467284926140"].arrayValue
                self.newsList = newsJsonArr.map {
                    let title = $0["title"].stringValue
                    let createTime = $0["ptime"].stringValue
                    let coverSrc = $0["imgsrc"].stringValue
                    return News(title: title, createTime: createTime, coverSrc: coverSrc)
                }
                self.tableView.reloadData()
            case .failure(let err):
                print(err)
            }
        }
    }
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: NewsTableViewCell
        if let rs = tableView.dequeueReusableCell(withIdentifier: cellId) as? NewsTableViewCell {
            cell = rs
        } else {
            cell = NewsTableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
            
        let news = newsList[indexPath.row]
        cell.titleLabel.text = news.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: news.createTime)
        cell.dateLabel.text = dateFormatter.string(from: date ?? Date.now)
        let url = URL(string: news.coverSrc.replacingOccurrences(of: "http:", with: "https:"))
        cell.coverImageView.kf.setImage(with: url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
