//
//  NesListViewController.swift
//  Architecture
//
//  Created by fooww on 2023/2/10.
//

import UIKit
import Kingfisher

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
    let newsModel = NewsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        newsModel.dataOnChanged = { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        newsModel.dataOnError = { [weak self] err in
            // 错误处理
        }
        
        newsModel.loadingChanged = { [weak self] loading in
            if loading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
        
        newsModel.fetchAllDatas()
        
//        activityIndicator.startAnimating()
//        newsModel.fetchAllDatas { success, errMsg in
//            self.activityIndicator.stopAnimating()
//            if success {
//                self.tableView.reloadData()
//            } else {
//                // 错误处理
//            }
//        }
    }
    
    // 上拉加载更多
    private func loadMore() {
//        activityIndicator.startAnimating()
//        newsModel.fetchPartDatas { success, errMsg in
//            self.activityIndicator.stopAnimating()
//            if success {
//                self.tableView.reloadData()
//            } else {
//                // 错误处理
//            }
//        }
        
        newsModel.fetchPartDatas()
    }
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: NewsTableViewCell
        if let rs = tableView.dequeueReusableCell(withIdentifier: cellId) as? NewsTableViewCell {
            cell = rs
        } else {
            cell = NewsTableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        let index = indexPath.row
        cell.titleLabel.text = newsModel.newsItemTitle(at: index)
        cell.dateLabel.text = newsModel.newsItemDate(at: index)
        cell.coverImageView.kf.setImage(with: newsModel.newsItemCoverUrl(at: index))
        cell.readCountLabel.text = newsModel.newsItemReadText(at: index)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsModel.addReadCount(index: indexPath.row)
    }
}
