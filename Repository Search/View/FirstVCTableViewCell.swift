//
//  FirstVCTableViewCell.swift
//  Repository Search
//
//  Created by 林佑淳 on 2024/6/20.
//

import UIKit

class FirstVCTableViewCell: UITableViewCell {
    
    var repository: Repository? {
        didSet {
            configureCell()
        }
    }
    
    private var ownerIconImg: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [repositoriesName, descriptionLbl])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private var repositoriesName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Default"
        return label
    }()
    
    var descriptionLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Default"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(ownerIconImg)
        contentView.addSubview(stackView)
        
        ownerIconImg.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ownerIconImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ownerIconImg.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ownerIconImg.widthAnchor.constraint(equalToConstant: 100),
            ownerIconImg.heightAnchor.constraint(equalToConstant: 100),
            stackView.leadingAnchor.constraint(equalTo: ownerIconImg.trailingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
        ])
    }
    
    func configureCell() {
        guard let repository = repository else { return }
        self.repositoriesName.text = repository.name
        self.descriptionLbl.text = repository.description
        if let url = URL(string: repository.owner.avatarUrl) {
            self.ownerIconImg.load(url: url)
        }
    }
}
