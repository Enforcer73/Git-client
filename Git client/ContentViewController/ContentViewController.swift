//
//  ContentViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 04.11.2021.


import UIKit
import Kingfisher

class ContentViewController: UIViewController {

    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var descriptLabel: UILabel!
    @IBOutlet private weak var langLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var tableContentCommit: UITableView!
    @IBOutlet private weak var labelLoad: UILabel!
    @IBOutlet private weak var loadSpiner: UIActivityIndicatorView!
    @IBOutlet private weak var viewLoad: UIView!
    
    private let contentModel = ContentModel()
    private var gitdata = [GitData]()
    private var selectedComm: GitData?
    private var model: GitData?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableContentCommit()
        configContent(with: model)
        contentModel.delegate = self
        loadSpiner.startAnimating()
    }
    
    
    //MAKE: - Accept data from VC
    private func configContent(with model: GitData?) {
        guard let model = model else { return }
        
        let url = URL(string: model.avatarUrl)
        userImage.kf.setImage(with: url)
        userLabel.text = model.login
        contentLabel.text = model.name
        descriptLabel.text = model.description
        langLabel.text = model.language
        forksLabel.text = "\(model.forksCount) forks"
        starsLabel.text = "\(model.stars) stars"
    }
    
    func set(model: GitData?) {
        self.model = model
    }
    
    
    //MAKE: - Announce Delegate & registering table
    private func configTableContentCommit() {
        tableContentCommit.delegate = self
        tableContentCommit.dataSource = self
        tableContentCommit.register(UINib(nibName: "ContentCommitTableViewCell", bundle: .main), forCellReuseIdentifier: "contCommit")
        contentModel.getGitData()
    }
    
    
    //MAKE: - Broadcast data to DetailCommitVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let commVC = segue.destination as? DetailCommitViewController {
            commVC.set(model: selectedComm)
        }
    }
}


extension ContentViewController: ContentModelDelegate {
    func dataDidReciveGitData(data: [GitData]) {
        DispatchQueue.main.async {[weak self] in
//            self?.labelLoad.textColor = .white
//            self?.labelLoad.text = "Данные загружены"
            self?.gitdata = data

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
                self?.tableContentCommit.reloadData()
                self?.labelLoad.isHidden = true
                self?.viewLoad.isHidden = true
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
extension ContentViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "contCommit", for: indexPath) as? ContentCommitTableViewCell {
            if gitdata.count > 0 && indexPath.row < gitdata.count {
                cell.configContentCommit(model: gitdata[indexPath.row])
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    //MAKE: - Touch processing by table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedComm = gitdata[indexPath.row]
        performSegue(withIdentifier: "contCommVC", sender: self)
    }
}
    
