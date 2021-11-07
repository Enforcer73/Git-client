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
    
    private var selectFavoritCommit: RepData?
    private var model: Reposit?
    
    private var dataRep = [
        RepData(name : "Tatarin", desc : "terwtwertew ertwertwetdgsdfgsdf ыа аыафываф аыфвыа", date : "1d", image: UIImage(named: "buh")),
        RepData(name : "Tatarin", desc : "terwtwertew ", date : "4d", image: UIImage(named: "buh")),
        RepData(name : "Tatarin", desc : "terwtwertew ertwertwetdgsdfgsdf", date : "1d", image: UIImage(named: "buh")),
        RepData(name : "Tatarin", desc : "terwtwertew ", date : "4d", image: UIImage(named: "buh")),
        RepData(name : "Tatarin", desc : "terwtwertew ertwertwetdgsdfgsdf", date : "1d", image: UIImage(named: "buh")),
        RepData(name : "Tatarin", desc : "terwtwertew ", date : "4d", image: UIImage(named: "buh")),
        RepData(name : "Tatarin", desc : "terwtwertew ertwertwetdgsdfgsdf", date : "1d", image: UIImage(named: "buh")),
        RepData(name : "Tatarin", desc : "terwtwertew ", date : "4d", image: UIImage(named: "buh")),
        RepData(name : "Tatarin", desc : "terwtwertew ertwertwetdgsdfgsdf", date : "1d", image: UIImage(named: "buh")),
        RepData(name : "Tatarin", desc : "terwtwertew ", date : "4d", image: UIImage(named: "buh"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableFavoritCommit()
        configFavoritCommit(with: model)
    }
    
    //MAKE: - Accept data from VCFavorit
    func configFavoritCommit(with model: Reposit?) {
        guard let model = model else { return }

        userLabel.text = model.name
        contentLabel.text = model.content
        descriptLabel.text = model.descript
        languageLabel.text = model.lang
        starsLabel.text = "\(model.star) stars"
        forksLabel.text = "\(model.fork) forks"
        if let image = model.image {
            userImage.image = image
        }
    }
    
    func set(model: Reposit?) {
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
            favVC.set(model: selectFavoritCommit)
        }
    }
}

//MAKE: - Create table
extension FavoritViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataRep.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favorCommit", for: indexPath) as? FavoritCommitTableViewCell {
            cell.configFavoritCommit(model: dataRep[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    //MAKE: - Touch processing by table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectFavoritCommit = dataRep[indexPath.row]
        performSegue(withIdentifier: "favorCommVC", sender: self)
    }
}
