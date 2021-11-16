//
//  ViewControllerFavorites.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 03.11.2021.
//

import UIKit
import Kingfisher
import RealmSwift
    

class FavoritesViewController: UIViewController {


    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadLabel: UILabel!
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!
    
    
    private let viewModel = FavoritesViewModel()
    private var gitData = [GitData]()
    private var selectedContent: GitData?
    private var commitsData = [CommitData]()
    private var selectedCommit: CommitData?
    private var selectedGitId: String?
    
    
    let localRealm = try! Realm()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableFavorit()
        viewModel.delegate = self
        loadSpinner.startAnimating()
        viewModel.fetchDataFromDataBase()
    }
    
    
    //MAKE: - Announce Delegate & registering table
    private func configTableFavorit() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: .main), forCellReuseIdentifier: "favoritCell")
    }
    
    
    //MAKE: - Broadcast data to DetailFavoritVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let favorVC = segue.destination as? DetailFavoritesViewController {
            favorVC.set(model: selectedContent)
        }
    }
}


//MAKE: - Requsting data from BD
extension FavoritesViewController: FavoritesViewModelDelegate {
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
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitData.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favoritCell", for: indexPath) as? FavoritesTableViewCell {
            cell.configDetailFavorit(model: gitData[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    //MAKE: - Select row to transfer
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContent = gitData[indexPath.row]
        performSegue(withIdentifier: "toDetailFavoritVC", sender: self)
    }
    
    //MAKE: - Style change status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
