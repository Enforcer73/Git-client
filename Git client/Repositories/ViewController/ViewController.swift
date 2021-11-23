//
//  ViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 02.11.2021.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseAuth
import RealmSwift

final class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadLabel: UILabel!
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!

    private let viewModel = ViewModel()
    private var realmData = [GitDataRealm]()
    private var selectedRealm: GitDataRealm?
    private var notificationToken: NotificationToken?

    //MARK: - Pull-to-refresh
    private let controlRefresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLabel.alpha = 0
        viewModel.delegate = self
        loadSpinner.startAnimating()
        tableView.refreshControl = controlRefresh
        configTableFirst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //MARK: - Refresh
    @objc private func refresh(sender: UIRefreshControl) {
        viewModel.getGitReposAndCommtis()
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    //MARK: - Announce Delegate & registering table
    private func configTableFirst() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register( UINib(nibName: "TableViewCell", bundle: .main), forCellReuseIdentifier: "viewCell")

        let results = viewModel.localRealm.objects(GitDataRealm.self)

        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in

            guard
                let self = self,
                let tableView = self.tableView
            else { return }

            switch changes {
            case .initial(_):
                self.viewModel.getGitReposAndCommtis()
                tableView.reloadData()
            case .update(_, _, _, _):
                self.viewModel.getGitReposAndCommtis()
                tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
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

    //MARK: - Broadcast model to DetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gitVC = segue.destination as? DetailViewController {
            gitVC.set(model: selectedRealm)
        }
    }
}

//MARK: - Data recive
extension ViewController: ViewModelDelegate {
    func dataDidReciveGitDataRealm(data: [GitDataRealm]) {
        DispatchQueue.main.async { [weak self] in
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
            self?.loadLabel.text = "Ошибка сети"
        }
    }
}

//MARK: - Create table
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "viewCell", for: indexPath) as? TableViewCell {
            cell.configCell(model: realmData[indexPath.row])
            cell.buttonAction = { [unowned self] in
                let model = self.realmData[indexPath.row]
                self.viewModel.saveGitdataToDataBase(model: model)
            }
            return cell
        } else {
            return  UITableViewCell()
        }
    }

    //MARK: - Touch processing by table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRealm = realmData[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: self)
    }
}
