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
    let newsViewModel = NewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        newsViewModel.dataOnChanged = { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        newsViewModel.dataOnError = { [weak self] err in
            // 错误处理
        }
        
        newsViewModel.loadingChanged = { [weak self] loading in
            if loading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
        
        newsViewModel.fetchAllDatas()
        
        newsViewModel.fetchPartDatas()
    }
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: NewsTableViewCell
        if let rs = tableView.dequeueReusableCell(withIdentifier: cellId) as? NewsTableViewCell {
            cell = rs
        } else {
            cell = NewsTableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        let cellViewModel = newsViewModel.cellViewModel(at: indexPath.row)
        cell.viewModel = cellViewModel
        // 绑定
        cellViewModel.readCountBind = {[weak cell] countText in
            cell?.readCountLabel.text = countText
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell else { return }
        
        // loading框界面由 外层newsView的newsPresenter负责 回调回来交由其处理
        newsViewModel.isLoading = true
        cell.viewModel.addReadCount { success, errMsg in
            self.newsViewModel.isLoading = false
        }
    }
}
