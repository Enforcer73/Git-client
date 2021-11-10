//
//  ViewControllerFavorites.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 03.11.2021.
//

import UIKit

    

class ViewControllerFavorites: UIViewController {

    @IBOutlet private weak var tableViewFavorit: UITableView!
    
    private var gitdata = [GitData]()
    private var selectedContent: GitData?
    

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
            favorVC.set(model: selectedContent)
        }
    }
}

//MAKE: - Create table
extension ViewControllerFavorites: UITableViewDelegate, UITableViewDataSource {
    
    //MAKE: - Create table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gitdata.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favoritCell", for: indexPath) as? TableViewCellFavorites {
            cell.configFavorit(model: gitdata[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    //MAKE: - Select row to transfer
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContent = gitdata[indexPath.row]
        performSegue(withIdentifier: "toFavor", sender: self)
    }
    
    //MAKE: - Style change status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
