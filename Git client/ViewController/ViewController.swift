//
//  ViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 02.11.2021.
//

import UIKit
import Kingfisher
import RealmSwift

class ViewController: UIViewController {

    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadLabel: UILabel!
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!
    
    private let viewModel = ViewModel()
    private var gitData = [GitData]()
    private var commitsData = [CommitData]()
    private var selectedContent: GitData?
    private var selectedCommit: CommitData?
    private var selectedGitId: String?
    

        
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableFirst()
        viewModel.delegate = self
        loadSpinner.startAnimating()
    }

    
    //MAKE: - Announce Delegate & registering table
    private func configTableFirst() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register( UINib(nibName: "TableViewCell", bundle: .main), forCellReuseIdentifier: "viewCell")
        viewModel.getGitData()
    }
    
    
    //MAKE: - Broadcast data to ContentVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gitVC = segue.destination as? DetailViewController {
            gitVC.set(model: selectedContent)
        }
    }
}


//MAKE: - Data recive
extension ViewController: ViewModelDelegate {
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
extension ViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitData.count
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "viewCell", for: indexPath) as? TableViewCell {
            cell.configCell(model: gitData[indexPath.row])
            return cell
        } else {
            return  UITableViewCell()
        }
    }
        
    //MAKE: - Touch processing by table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContent = gitData[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: self)
    }
        
    //MAKE: - Style change status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
