//
//  NewsTableViewCell.swift
//  Architecture
//
//  Created by fooww on 2023/2/10.
//

import UIKit
import SnapKit

class NewsTableViewCell: UITableViewCell {

    var viewModel: NewsCellViewModel = NewsCellViewModel() {
        didSet {
            configData()
        }
    }
    
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let coverImageView = UIImageView()
    let readCountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        titleLabel.textColor = .black
        dateLabel.textColor = .gray
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.masksToBounds = true
        readCountLabel.textColor = .red
        readCountLabel.textAlignment = .right
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(coverImageView)
        contentView.addSubview(readCountLabel)
        
        self.coverImageView.snp.makeConstraints({ make in
            make.height.equalToSuperview()
            make.width.equalTo(coverImageView.snp.height).multipliedBy(2)
            make.right.equalTo(0)
        })
        self.titleLabel.snp.makeConstraints({ make in
            make.top.left.equalTo(10)
            make.right.equalTo(coverImageView.snp.left).offset(-10)
        })
        self.readCountLabel.snp.makeConstraints({ make in
            make.right.equalTo(coverImageView.snp.left).offset(-10)
            make.bottom.equalTo(-10)
        })
        self.dateLabel.snp.makeConstraints({ make in
            make.left.equalTo(10)
            make.bottom.equalTo(-10)
            make.right.equalTo(readCountLabel.snp.left).offset(-10)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configData() {
        titleLabel.text = viewModel.newsItemTitle()
        dateLabel.text = viewModel.newsItemDate()
        coverImageView.kf.setImage(with: viewModel.newsItemCoverUrl())
        readCountLabel.text = viewModel.newsItemReadText()
    }
}

