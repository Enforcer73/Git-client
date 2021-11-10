//
//  DetailCommitViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 06.11.2021.
//
import UIKit
import Kingfisher


class DetailCommitViewController: UIViewController {

    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var descriptLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var tableDetailCommit: UITableView!
    @IBOutlet private weak var labelLoad: UILabel!
    @IBOutlet private weak var loadSpiner: UIActivityIndicatorView!
    
    private let commitModel = DetailCommitModel()
    private var gitdata = [GitData]()
    private var selectedContent: GitData?
    private var model: GitData?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configDetailCommit(with: model)
        configTableDetailCommit()
        commitModel.delegate = self
        loadSpiner.startAnimating()
    }
    
    
    //MAKE: - Accept data from ContentVC
    func configDetailCommit(with model: GitData?) {
        guard let model = model else { return }

        userLabel.text = model.login
        descriptLabel.text = model.description
        dateLabel.text = model.updatedAtFormatted
        let url = URL(string: model.avatarUrl)
        userImage.kf.setImage(with: url)
    }
    
    
    func set(model: GitData?) {
        self.model = model
    }
    
    
    //MAKE: - Announce Delegate & registering table
    private func configTableDetailCommit() {
        tableDetailCommit.delegate = self
        tableDetailCommit.dataSource = self
        tableDetailCommit.register(UINib(nibName: "DetailCommitTableViewCell", bundle: .main), forCellReuseIdentifier: "detailCommit")
        commitModel.getGitData()
    }
}


extension DetailCommitViewController: DetailCommitModelDelegate {
    func dataDidReciveGitData(data: [GitData]) {
        DispatchQueue.main.async {[weak self] in
//            self?.labelLoad.textColor = .white
//            self?.labelLoad.text = "Данные загружены"
            self?.gitdata = data
            

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
                self?.tableDetailCommit.reloadData()
                self?.labelLoad.isHidden = true
                self?.loadSpiner.hidesWhenStopped = true
                self?.loadSpiner.stopAnimating()
            }
        }
    }

    func error() {
        DispatchQueue.main.async {[weak self] in
            self?.labelLoad.textColor = .red
            self?.labelLoad.text = "Ошибка сети"
        }
    }
}


//MAKE: - Create table
extension DetailCommitViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gitdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "detailCommit", for: indexPath) as? DetailCommitTableViewCell {
            cell.configLabelCommit(model: gitdata[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
