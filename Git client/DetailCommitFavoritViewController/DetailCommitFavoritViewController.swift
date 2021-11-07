//
//  DetailCommitFavoritViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 06.11.2021.
//

import UIKit

class DetailCommitFavoritViewController: UIViewController {

    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var descriptLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var tableDetailCommitFavorit: UITableView!
    
    private var selectCommit: Commit?
    private var model: RepData?
    
    private var commitCode = [
        Commit(codCom : "if let cell = tableView.dequeueReusableCell(withIdentifier: \"firstCell\", for: indexPath) as? TableViewCell")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDetailCommitFavorit(with: model)
        configTableDetailCommitFavorit()
    }
    
    //MAKE: - Accept data from FavoritVC
    func configDetailCommitFavorit(with model: RepData?) {
        guard let model = model else { return }

        userLabel.text = model.name
        descriptLabel.text = model.desc
        dateLabel.text = model.date
        if let image = model.image {
            userImage.image = image
        }
    }

    func set(model: RepData?) {
        self.model = model
    }
    
    //MAKE: - Announce Delegate & registering table
    func configTableDetailCommitFavorit() {
        tableDetailCommitFavorit.delegate = self
        tableDetailCommitFavorit.dataSource = self
        tableDetailCommitFavorit.register(UINib(nibName: "DetailCommitFavoritTableViewCell", bundle: .main), forCellReuseIdentifier: "detailCommFavor")
    }
}

//MAKE: - Create table
extension DetailCommitFavoritViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commitCode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "detailCommFavor", for: indexPath) as? DetailCommitFavoritTableViewCell {
            cell.configDetailCommitFavorit(model: commitCode[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}