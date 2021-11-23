//
//  ContentViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 04.11.2021.


import UIKit
import Kingfisher
import RealmSwift

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var descriptLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadLabel: UILabel!
    @IBOutlet private weak var loadSpinner: UIActivityIndicatorView!

    private let viewModel = ViewModel()
    private var realmData = [GitDataRealm]()
    private var model: GitDataRealm?

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
        configTableContentCommit()
        configContent(with: model)
        viewModel.delegate = self
        loadSpinner.startAnimating()
        tableView.refreshControl = controlRefresh
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //MARK: - Refresh
    @objc private func refresh(sender: UIRefreshControl) {
        viewModel.getGitReposAndCommtis()
        tableView.reloadData()
        sender.endRefreshing()
    }

    //MARK: - Alert
    private func showAlert() {
    let alert = UIAlertController(title: "Сохранено!", message: "Репозиторий сохранён в Избранное", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            self.navigationController?.popToRootViewController(animated: true)
        })
            present(alert, animated: true, completion: nil)
    }

    //MARK: - Action save repo data to DB
    @IBAction func addReposToFavorite(_ sender: Any) {
        guard let model = model else { return }
        viewModel.saveGitdataToDataBase(model: model)
        showAlert()
    }

    //MARK: - Accept data from VC
    private func configContent(with model: GitDataRealm?) {
        
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

    //MARK: - Accept model from VC
    func set(model: GitDataRealm?) {
        self.model = model
    }

    //MARK: - Announce Delegate & registering table
    private func configTableContentCommit() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: .main), forCellReuseIdentifier: "detailCell")
        viewModel.getGitReposAndCommtis()
    }
}

//MARK: - Data recive
extension DetailViewController: ViewModelDelegate {
    func dataDidReciveGitDataRealm(data: [GitDataRealm]) {
        DispatchQueue.main.async {[weak self] in
            self?.realmData = data

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
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model else {return 0 }
        return model.commits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? DetailTableViewCell,
           let model = model?.commits[indexPath.row] {
            cell.configDetailCell(model: model)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
