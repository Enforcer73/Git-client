//
//  DetailCommitViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 06.11.2021.
//
import UIKit

struct Commit {
    let codCom: String
}

class DetailCommitViewController: UIViewController {

    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var descriptLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var tableDetailCommit: UITableView!
    
    private var selectCommit: Commit?
    private var model: RepData?
    
    private var commitCode = [
        Commit(codCom : "if let cell = tableView.dequeueReusableCell(withIdentifier: \"firstCell\", for: indexPath) as? TableViewCell")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDetailCommit(with: model)
        configTableDetailCommit()
    }
    
    //MAKE: - Accept data from ContentVC
    func configDetailCommit(with model: RepData?) {
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
    private func configTableDetailCommit() {
        tableDetailCommit.delegate = self
        tableDetailCommit.dataSource = self
        tableDetailCommit.register(UINib(nibName: "DetailCommitTableViewCell", bundle: .main), forCellReuseIdentifier: "detailCommit")
    }
}

//MAKE: - Create table
extension DetailCommitViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commitCode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "detailCommit", for: indexPath) as? DetailCommitTableViewCell {
            cell.configLabelCommit(model: commitCode[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
