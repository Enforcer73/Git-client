//
//  ViewControllerFavorites.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 03.11.2021.
//

import UIKit

    

class ViewControllerFavorites: UIViewController {

    @IBOutlet private weak var tableViewFavorit: UITableView!
    
    private var selectedFavorit: Reposit?
    
    private var data = [
        Reposit(name : "Tatarin", content : "works", descript : "чики пуки", lang : "swift", fork : "1", star : "5", image: UIImage(named: "buh")),
        Reposit(name : "Enforcer", content : "fail code", descript : "adsa aadfgdfddsfsfewf sfs fsfsdfsdfsf sf sfss fsfsdfsdfs", lang : "swift", fork : "1", star : "1", image: UIImage(named: "valak")),
        Reposit(name : "Tatarin", content : "works", descript : "чики пуки", lang : "swift", fork : "1", star : "5", image: UIImage(named: "buh")),
        Reposit(name : "Enforcer", content : "fail code", descript : "adsa aadfgdfddsfsfewf sfs fsfsdfsdfsf sf sfss fsfsdfsdfs", lang : "swift", fork : "1", star : "1", image: UIImage(named: "valak")),
        Reposit(name : "Tatarin", content : "works", descript : "чики пуки", lang : "swift", fork : "1", star : "5", image: UIImage(named: "buh")),
        Reposit(name : "Enforcer", content : "fail code", descript : "adsa aadfgdfddsfsfewf sfs fsfsdfsdfsf sf sfss fsfsdfsdfs", lang : "swift", fork : "1", star : "1", image: UIImage(named: "valak"))
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
    
    //MAKE: - Broadcast data to FavoritVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let favorVC = segue.destination as? FavoritViewController {
            favorVC.set(model: selectedFavorit)
        }
    }
}

//MAKE: - Create table
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
            cell.configFavorit(model: data[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    //MAKE: - Select row to transfer
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFavorit = data[indexPath.row]
        performSegue(withIdentifier: "toFavor", sender: self)
    }
    
    //MAKE: - Style change status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
