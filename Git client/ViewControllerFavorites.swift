//
//  ViewControllerFavorites.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 03.11.2021.
//

import UIKit

struct Repos {
    let name: String
    let content: String
    let descript: String
    let lang: String
    let fork: String
    let star: String
}
    

class ViewControllerFavorites: UIViewController {

    @IBOutlet private weak var tableViewFavorit: UITableView!
    
    private var data = [
        Repos(name : "Tatarin", content : "works", descript : "чики пуки", lang : "swift", fork : "1", star : "5"),
        Repos(name : "Tatarin", content : "fail code", descript : "adsa aadfgdfddsfsfewf sfs fsfsdfsdfsf sf sfss fsfsdfsdfs", lang : "swift", fork : "1", star : "1")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableFavorit()
    }
    
    //MAKE: - Announce Delegate & registering table
    private func configTableFavorit() {
        tableViewFavorit.delegate = self
        tableViewFavorit.dataSource = self
        tableViewFavorit.register(UINib(nibName: "TableViewCellFavorites", bundle: .main), forCellReuseIdentifier: "favoritCell")
    }
}

extension ViewControllerFavorites: UITableViewDelegate, UITableViewDataSource {
    
    //MAKE: - Create table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favoritCell", for: indexPath) as? TableViewCellFavorites {
            cell.configFavorit(nick: data[indexPath.row].name,
                               content: data[indexPath.row].content,
                               descript: data[indexPath.row].descript,
                               lang: data[indexPath.row].lang,
                               fork: data[indexPath.row].fork,
                               star: data[indexPath.row].star)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
