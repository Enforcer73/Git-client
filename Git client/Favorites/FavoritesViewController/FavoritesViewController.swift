//
//  ViewControllerFavorites.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 03.11.2021.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseAuth
import RealmSwift

final class FavoritesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadLabel: UILabel!
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!

    private let viewModel = ViewModel()
    private let favorModel = FavoritesViewModel()
    private var realmData = [GitDataRealm]()
    private var selectedRealm: GitDataRealm?
    private var notificationToken: NotificationToken?

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
        loadSpinner.startAnimating()
        configTableFavorit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favorModel.updateData()
        tableView.reloadData()
    }

    //MARK: - Refresh
    @objc private func refresh(sender: UIRefreshControl) {
        favorModel.updateData()
        tableView.reloadData()
        sender.endRefreshing()
    }

    //MARK: - Announce Delegate & registering table
    private func configTableFavorit() {
        favorModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        self.loadLabel.isHidden = true
        self.loadSpinner.hidesWhenStopped = true
        self.loadSpinner.stopAnimating()
        tableView.refreshControl = controlRefresh

        let cellNib = UINib(nibName: "FavoritesTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "favoritCell")

        let results = viewModel.localRealm.objects(GitDataRealm.self)

        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in

            guard
                let self = self,
                let tableView = self.tableView
            else { return }

            switch changes {
            case .initial(_):
                self.favorModel.updateData()
                tableView.reloadData()
            case .update(_, _, _, _):
                self.favorModel.updateData()
                tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    //MARK: - Alert
    private func showAlert() {
    let alert = UIAlertController(title: "Удалено!", message: "Репозиторий удалён из Избранного", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            self.favorModel.updateData()
            self.tableView.reloadData()
        })
            present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Sign Out
    @IBAction private func signOutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: - Broadcast model to DetailFavoritVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let favorVC = segue.destination as? DetailFavoritesViewController {
            favorVC.set(model: selectedRealm)
        }
    }
}

//MARK: - Requsting data from BD
extension FavoritesViewController: FavoritesViewModelDelegate {

    func dataDidReciveDataFromDataBase(data: [GitDataRealm]) {
        self.realmData = data
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tableView.reloadData()
                self?.loadLabel.isHidden = true
                self?.loadSpinner.hidesWhenStopped = true
                self?.loadSpinner.stopAnimating()
            }
        }
    }

    func error() {
        DispatchQueue.main.async { [weak self] in
            self?.loadLabel.alpha = 1
            self?.loadLabel.textColor = .red
            self?.loadLabel.text = "Ошибка сети"
        }
    }
}

//MARK: - Create table
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorModel.modelsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favoritCell", for: indexPath) as? FavoritesTableViewCell {
            cell.configDetailFavorit(model: favorModel.get(model: indexPath.row))
            cell.removeAction = { [unowned self] in
                let model = self.favorModel.favModels[indexPath.row]
                self.viewModel.removeFavoritToDataBase(model: model)
            }
            return cell
        }
        else {
            return UITableViewCell()
        }
    }

    //MARK: - Touch processing by table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRealm = favorModel.get(model: indexPath.row)
        performSegue(withIdentifier: "toDetailFavoritVC", sender: self)
    }
}
