//
//  ViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 02.11.2021.
//

import UIKit
import Kingfisher


class ViewController: UIViewController {

    
    @IBOutlet private weak var tableViewFirst: UITableView!
    @IBOutlet private weak var labelLoad: UILabel!
    @IBOutlet weak var loadSpiner: UIActivityIndicatorView!
    
    private let viewModel = ViewModel()
    private var gitdata = [GitData]()
    private var selectedContent: GitData?
    

        
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableFirst()
        viewModel.delegate = self
        loadSpiner.startAnimating()
    }

    //MAKE: - Announce Delegate & registering table
    private func configTableFirst() {
        tableViewFirst.delegate = self
        tableViewFirst.dataSource = self
        tableViewFirst.register( UINib(nibName: "TableViewCell", bundle: .main), forCellReuseIdentifier: "firstCell")
        viewModel.getGitData()
    }
        
    //MAKE: - Broadcast data to ContentVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let contVC = segue.destination as? ContentViewController {
            contVC.set(model: selectedContent)
        }
    }
}


extension ViewController: ViewModelDelegate {
    func dataDidReciveGitData(data: [GitData]) {
        DispatchQueue.main.async {[weak self] in
//            self?.labelLoad.textColor = .white
//            self?.labelLoad.text = "Данные загружены"
            self?.gitdata = data
            
            

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
                self?.tableViewFirst.reloadData()
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
extension ViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gitdata.count
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as? TableViewCell {
            cell.configFirst(model: gitdata[indexPath.row])
            return cell
        } else {
            return  UITableViewCell()
        }
    }
        
    //MAKE: - Touch processing by table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContent = gitdata[indexPath.row]
        performSegue(withIdentifier: "toCont", sender: self)
    }
        
    //MAKE: - Style change status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

