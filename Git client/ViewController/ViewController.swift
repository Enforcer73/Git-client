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
    let image: UIImage?
}

class ViewController: UIViewController {

    
    @IBOutlet private weak var tableViewFirst: UITableView!
    
    private var selectedContent: Reposit?
        
    private var data = [
        Reposit(name : "Enforcer", content : "lesson", descript : "terwtwertew ertwertwetdgsdfgsdf sdfgsdfg sdfgsdfg", lang : "swift", fork: "1", star : "1", image: UIImage(named: "valak")),
        Reposit(name : "Tatarin", content : "works", descript : "чики пуки", lang : "swift", fork : "1", star : "5", image: UIImage(named: "buh")),
        Reposit(name : "Enforcer", content : "lesson", descript : "terwtwertew ertwertwetdgsdfgsdf sdfgsdfg sdfgsdfg", lang : "swift", fork: "1", star : "1", image: UIImage(named: "valak")),
        Reposit(name : "Tatarin", content : "works", descript : "чики пуки", lang : "swift", fork : "1", star : "5", image: UIImage(named: "buh")),
        Reposit(name : "Enforcer", content : "lesson", descript : "terwtwertew ertwertwetdgsdfgsdf sdfgsdfg sdfgsdfg", lang : "swift", fork: "1", star : "1", image: UIImage(named: "valak")),
        Reposit(name : "Tatarin", content : "works", descript : "чики пуки", lang : "swift", fork : "1", star : "5", image: UIImage(named: "buh"))
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
        
    //MAKE: - Broadcast data to ContentVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let contVC = segue.destination as? ContentViewController {
            contVC.set(model: selectedContent)
        }
    }
}

//MAKE: - Create table
extension ViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as? TableViewCell {
            cell.configFirst(model: data[indexPath.row])
            return cell
        } else {
            return  UITableViewCell()
        }
    }
        
    //MAKE: - Touch processing by table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContent = data[indexPath.row]
        performSegue(withIdentifier: "toCont", sender: self)
    }
        
    //MAKE: - Style change status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

