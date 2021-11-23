//
//  FavoritViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 04.11.2021.
//

import UIKit
import Kingfisher

final class DetailFavoritesViewController: UIViewController {

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
    private let viewModels = ViewModel()
    private var commitsData = [GitDataRealm]()
    private var model: GitDataRealm?
    private let dataBase = RealmProvider()
 
    //MARK: - Pull-to-refresh
    let controlRefresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLabel.alpha = 0
        configTableFavoritCommit()
        configDetailFavorit(with: model)
        viewModel.delegate = self
        loadSpinner.startAnimating()
        tableView.refreshControl = controlRefresh
        viewModel.fetchDataFromDataBase()
    }

    //MARK: - Refresh
    @objc private func refresh(sender: UIRefreshControl) {
        viewModel.fetchDataFromDataBase()
        tableView.reloadData()
        sender.endRefreshing()
    }

    //MARK: - Alert
    private func showAlert() {
    let alert = UIAlertController(title: "Удалено!", message: "Репозиторий удалён из Избранного", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            self.navigationController?.popToRootViewController(animated: true)
        })
            present(alert, animated: true, completion: nil)
    }

    //MARK: - Action remove repo from DB
    @IBAction func removeReposFromFavorite(_ sender: Any) {
        guard let model = model else { return }
        viewModels.removeFavoritToDataBase(model: model)
        showAlert()
    }

    //MARK: - Accept data from DetailFavoritVC
    func configDetailFavorit(with model: GitDataRealm?) {
        guard let model = model else { return }
        
        let url = URL(string: model.repo?.avatarUrl ?? "")
        userImage.kf.setImage(with: url)

        userLabel.text = model.repo?.login
        contentLabel.text = model.repo?.nameRep
        descriptLabel.text = model.repo?.descript
        languageLabel.text = model.repo?.language
        forksLabel.text = "\(model.repo?.forksCount ?? 0) forks"
        starsLabel.text = "\(model.repo?.stars ?? 0) stars"
    }

    //MARK: - Accept model from FavoritesVC
    func set(model: GitDataRealm?) {
        self.model = model
    }

    //MARK: - Announce Delegate & registering table
    private func configTableFavoritCommit() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DetailFavoritesTableViewCell", bundle: .main), forCellReuseIdentifier: "favorDetailCell")
        viewModel.fetchDataFromDataBase()
    }
}

//MARK: - Data recive from DB
extension DetailFavoritesViewController: FavoritesViewModelDelegate {
    func dataDidReciveDataFromDataBase(data: [GitDataRealm]) {
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
            self?.loadLabel.alpha = 1
            self?.loadLabel.textColor = .red
            self?.loadLabel.text = "network error"
        }
    }
}

//MARK: - Create table
extension DetailFavoritesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model else {return 0 }
        return model.commits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favorDetailCell", for: indexPath) as? DetailFavoritesTableViewCell,
           let model = model?.commits[indexPath.row] {
            cell.configDetaiFavoriteTable(model: model)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
