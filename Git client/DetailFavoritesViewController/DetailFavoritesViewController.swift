//
//  FavoritViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 04.11.2021.
//

import UIKit
import Kingfisher
import RealmSwift


class DetailFavoritesViewController: UIViewController {

    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var descriptLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadLabel: UILabel!
    @IBOutlet private weak var loadSpinner: UIActivityIndicatorView!
    
    
    private let viewModel = FavoritesViewModel()
    private var gitData = [GitData]()
    private var commitsData = [CommitData]()
    private var model: GitData?
    
    
   
    private let localRealm = try! Realm()
    
    var gitId = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableFavoritCommit()
        configDetailFavorit(with: model)
        viewModel.delegate = self
        loadSpinner.startAnimating()
        viewModel.fetchCommitFromDataBase()
    }
    
    
    //MAKE: - Accept data from DetailFavoritVC
    func configDetailFavorit(with model: GitData?) {
        guard let model = model else { return }

        let url = URL(string: model.avatarUrl ?? "")
        userImage.kf.setImage(with: url)
        userLabel.text = model.login
        contentLabel.text = model.nameRep
        descriptLabel.text = model.descript
        languageLabel.text = model.language
        starsLabel.text = "\(model.stars ?? 0) stars"
        forksLabel.text = "\(model.forksCount ?? 0) forks"
    }
    
    func set(model: GitData?) {
        self.model = model
    }
    
    
    //MAKE: - Announce Delegate & registering table
    private func configTableFavoritCommit() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DetailFavoritesTableViewCell", bundle: .main), forCellReuseIdentifier: "favorDetailCell")
    }
}


//MAKE: - Requsting data from BD
extension DetailFavoritesViewController: FavoritesViewModelDelegate {
    func dataDidReciveGitFromDataBase(data: [GitData]) {
        self.gitData = data
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
                self?.tableView.reloadData()
                self?.loadLabel.isHidden = true
                self?.loadSpinner.hidesWhenStopped = true
                self?.loadSpinner.stopAnimating()
            }
        }
    }
    
    func dataDidReciveCommitFromDataBase(data: [CommitData]) {
        self.commitsData = data
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
                self?.tableView.reloadData()
                self?.loadLabel.isHidden = true
                self?.loadSpinner.hidesWhenStopped = true
                self?.loadSpinner.stopAnimating()
            }
        }
    }
    
    func error() {
        DispatchQueue.main.async {[weak self] in
            self?.loadLabel.textColor = .red
            self?.loadLabel.text = "network error"
            
        }
    }
}


//MAKE: - Create table
extension DetailFavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commitsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favorDetailCell", for: indexPath) as? DetailFavoritesTableViewCell {
            cell.configDetaiFavoriteTable(model: commitsData[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
