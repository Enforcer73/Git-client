//
//  ContentViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 04.11.2021.


import UIKit
import Kingfisher
import RealmSwift

class DetailViewController: UIViewController {

    
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
    private var gitData = [GitData]()
    private var commitsData = [CommitData]()
    private var model: GitData?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableContentCommit()
        configContent(with: model)
        viewModel.delegate = self
        loadSpinner.startAnimating()
    }
    
    
    //MAKE: - Action saving data to db
    @IBAction func addReposToFavorite(_ sender: Any) {
        viewModel.saveGitdataToDataBase(model: gitData)
        viewModel.saveCommitsdataToDataBase(model: commitsData)
    }
    
    
    //MAKE: - Accept data from VC
    private func configContent(with model: GitData?) {
        guard let model = model else { return }
        
        let url = URL(string: model.avatarUrl ?? "")
        userImage.kf.setImage(with: url)
        userLabel.text = model.login
        contentLabel.text = model.nameRep
        descriptLabel.text = model.descript
        languageLabel.text = model.language
        forksLabel.text = "\(model.forksCount ?? 0) forks"
        starsLabel.text = "\(model.stars ?? 0) stars"
    }
    
    func set(model: GitData?) {
        self.model = model
    }
 
    
    //MAKE: - Announce Delegate & registering table
    private func configTableContentCommit() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: .main), forCellReuseIdentifier: "detailCell")
        guard let fullName = model?.fullName else { return }
        viewModel.getCommitsData(fullName: fullName)
        viewModel.getGitData()
    }
}


//MAKE: - Data recive
extension DetailViewController: ViewModelDelegate {
    func dataDidReciveCommits(data: [CommitData]) {
        DispatchQueue.main.async {[weak self] in
            self?.commitsData = data
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
                self?.tableView.reloadData()
                self?.loadLabel.isHidden = true
                self?.loadSpinner.hidesWhenStopped = true
                self?.loadSpinner.stopAnimating()
            }
        }
    }
    
    func dataDidReciveGitData(data: [GitData]) {
        DispatchQueue.main.async {[weak self] in
            self?.gitData = data

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
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commitsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? DetailTableViewCell {
            cell.configDetailCell(model: commitsData[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
