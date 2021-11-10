//
//  FavoritViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 04.11.2021.
//

import UIKit

class FavoritViewController: UIViewController {

    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var descriptLabel: UILabel!
    @IBOutlet private weak var tableFavoritCommit: UITableView!
    
    private var gitdata = [GitData]()
    private var selectedContent: GitData?
    private var model: GitData?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableFavoritCommit()
        configFavoritCommit(with: model)
    }
    
    //MAKE: - Accept data from VCFavorit
    func configFavoritCommit(with model: GitData?) {
        guard let model = model else { return }

        userLabel.text = model.login
        contentLabel.text = model.commits
        descriptLabel.text = model.description
        languageLabel.text = model.language
        starsLabel.text = "\(model.stars) stars"
        forksLabel.text = "\(model.forksCount) forks"
//        if let image = model.image {
//            userImage.image = image
//        }
    }
    
    func set(model: GitData?) {
        self.model = model
    }
    
    //MAKE: - Announce Delegate & registering table
    private func configTableFavoritCommit() {
        tableFavoritCommit.delegate = self
        tableFavoritCommit.dataSource = self
        tableFavoritCommit.register(UINib(nibName: "FavoritCommitTableViewCell", bundle: .main), forCellReuseIdentifier: "favorCommit")
    }
    
    //MAKE: - Broadcast data to DetailCommitFavoritVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let favVC = segue.destination as? DetailCommitFavoritViewController {
            favVC.set(model: selectedContent)
        }
    }
}

//MAKE: - Create table
extension FavoritViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gitdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favorCommit", for: indexPath) as? FavoritCommitTableViewCell {
            cell.configFavoritCommit(model: gitdata[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    //MAKE: - Touch processing by table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContent = gitdata[indexPath.row]
        performSegue(withIdentifier: "favorCommVC", sender: self)
    }
}
