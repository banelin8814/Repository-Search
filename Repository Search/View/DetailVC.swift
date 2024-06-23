//
//  SecondVC.swift
//  Repository Search
//
//  Created by 林佑淳 on 2024/6/20.
//

import UIKit

class DetailVC: UIViewController {

    lazy var ownerIconImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ownerIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var programLanguageLbl: UILabel = {
        let label = UILabel()
        label.text = "bigProgramLanguage"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var writtenInLbl: UILabel = {
        let label = UILabel()
        label.text = "writtenIn"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    lazy var starsLbl: UILabel = {
        let label = UILabel()
        label.text = "star"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    lazy var watcherLbl: UILabel = {
        let label = UILabel()
        label.text = "watchers"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    lazy var forkLbl: UILabel = {
        let label = UILabel()
        label.text = "forks"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    lazy var issueLbl: UILabel = {
        let label = UILabel()
        label.text = "issues"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
        self.navigationItem.title = ""
    }
    
    func setUpUI() {
        view.addSubview(ownerIconImg)
        view.addSubview(programLanguageLbl)
        view.addSubview(writtenInLbl)
        view.addSubview(starsLbl)
        view.addSubview(watcherLbl)
        view.addSubview(forkLbl)
        view.addSubview(issueLbl)
        
        ownerIconImg.translatesAutoresizingMaskIntoConstraints = false
        programLanguageLbl.translatesAutoresizingMaskIntoConstraints = false
        writtenInLbl.translatesAutoresizingMaskIntoConstraints = false
        starsLbl.translatesAutoresizingMaskIntoConstraints = false
        watcherLbl.translatesAutoresizingMaskIntoConstraints = false
        forkLbl.translatesAutoresizingMaskIntoConstraints = false
        issueLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
    
            ownerIconImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            ownerIconImg.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ownerIconImg.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ownerIconImg.heightAnchor.constraint(equalTo: ownerIconImg.widthAnchor, multiplier: 1),
            
            programLanguageLbl.topAnchor.constraint(equalTo: ownerIconImg.bottomAnchor, constant: 0),
            programLanguageLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            programLanguageLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            programLanguageLbl.heightAnchor.constraint(equalToConstant: 90),
            
            writtenInLbl.topAnchor.constraint(equalTo: programLanguageLbl.bottomAnchor, constant: 0),
            writtenInLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            writtenInLbl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            
            starsLbl.topAnchor.constraint(equalTo: writtenInLbl.topAnchor),
            starsLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            writtenInLbl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            forkLbl.heightAnchor.constraint(equalToConstant: 20),
            
            watcherLbl.topAnchor.constraint(equalTo: starsLbl.bottomAnchor, constant: 20),
            watcherLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            writtenInLbl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            watcherLbl.heightAnchor.constraint(equalToConstant: 20),
            
            forkLbl.topAnchor.constraint(equalTo: watcherLbl.bottomAnchor, constant: 20),
            forkLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            writtenInLbl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            forkLbl.heightAnchor.constraint(equalToConstant: 20),
            
            issueLbl.topAnchor.constraint(equalTo: forkLbl.bottomAnchor, constant: 20),
            issueLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            writtenInLbl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            issueLbl.heightAnchor.constraint(equalToConstant: 20),

        ])
    }
    
    func configUIContent(_ repository: Repository) {
        if let url = URL(string: repository.owner.avatarUrl) {
            self.ownerIconImg.load(url: url)
        }
        DispatchQueue.main.async {
            self.navigationItem.title = repository.name
            print(repository.name)
            self.programLanguageLbl.text = repository.name
            self.writtenInLbl.text = "written in \(repository.language ?? "")"
            self.starsLbl.text = "\(repository.stargazersCount) stars"
            self.watcherLbl.text = "\(repository.watchersCount) watchers"
            self.forkLbl.text = "\(repository.forksCount) forks"
            self.issueLbl.text = "\(repository.openIssuesCount) open issues"
        }
    }
}
