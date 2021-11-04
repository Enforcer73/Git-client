//
//  ViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 02.11.2021.
//

import UIKit


struct Reposit {
    let name: String
    let content: String
    let descript: String
    let lang: String
    let fork: String
    let star: String
}

class ViewController: UIViewController {

    
    @IBOutlet private weak var tableViewFirst: UITableView!
    
    private var data = [
        Reposit(name : "Enforcer", content : "lesson", descript : "terwtwertew ertwertwetdgsdfgsdf sdfgsdfg sdfgsdfg", lang : "swift", fork: "1", star : "1"),
        Reposit(name : "Tatarin", content : "works", descript : "чики пуки", lang : "swift", fork : "1", star : "5"),
        Reposit(name : "Enforcer", content : "lesson", descript : "terwtwertew ertwertwetdgsdfgsdf sdfgsdfg sdfgsdfg", lang : "swift", fork: "1", star : "1"),
        Reposit(name : "Tatarin", content : "works", descript : "чики пуки", lang : "swift", fork : "1", star : "5"),Reposit(name : "Enforcer", content : "lesson", descript : "terwtwertew ertwertwetdgsdfgsdf sdfgsdfg sdfgsdfg", lang : "swift", fork: "1", star : "1"),
        Reposit(name : "Tatarin", content : "works", descript : "чики пуки", lang : "swift", fork : "1", star : "5")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableFirst()
    }

    //MAKE: - Announce Delegate & registering table
    private func configTableFirst() {
        tableViewFirst.delegate = self
        tableViewFirst.dataSource = self
        tableViewFirst.register( UINib(nibName: "TableViewCell", bundle: .main), forCellReuseIdentifier: "firstCell")
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MAKE: - Create table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as? TableViewCell {
            cell.configFirst(nick: data[indexPath.row].name,
                             content: data[indexPath.row].content,
                             descript: data[indexPath.row].descript,
                             lang: data[indexPath.row].lang,
                             fork: data[indexPath.row].fork,
                             star: data[indexPath.row].star)
            return cell
        } else {
            return  UITableViewCell()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

