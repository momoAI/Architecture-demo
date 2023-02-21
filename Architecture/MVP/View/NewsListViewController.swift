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
    let newsPresenter = NewsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        newsPresenter.dataOnChanged = { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        newsPresenter.dataOnError = { [weak self] err in
            // 错误处理
        }
        
        newsPresenter.loadingChanged = { [weak self] loading in
            if loading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
        
        newsPresenter.fetchAllDatas()
        
        newsPresenter.fetchPartDatas()
    }
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsPresenter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: NewsTableViewCell
        if let rs = tableView.dequeueReusableCell(withIdentifier: cellId) as? NewsTableViewCell {
            cell = rs
        } else {
            cell = NewsTableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        let cellPresenter = newsPresenter.cellPresenter(at: indexPath.row)
        cell.presenter = cellPresenter
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell else { return }
        
        // loading框界面由 外层newsView的newsPresenter负责 回调回来交由其处理
        newsPresenter.isLoading = true
        cell.presenter.addReadCount { success, errMsg in
            self.newsPresenter.isLoading = false
        }
    }
}
