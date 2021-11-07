//
//  ContentViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 04.11.2021.
//
struct RepData {
    let name: String
    let desc: String
    let date: String
    let image: UIImage?
}


import UIKit

class ContentViewController: UIViewController {

    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var descriptLabel: UILabel!
    @IBOutlet private weak var langLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var tableContentCommit: UITableView!
    
    private var selectContCommit: RepData?
    private var model: Reposit?
    
    private var dataRep = [
        RepData(name : "Enforcer", desc : "terwtwertew ertwertwetdgsdfgsdf ыа аыафываф аыфвыа", date : "1d", image: UIImage(named: "valak")),
        RepData(name : "Enforcer", desc : "terwtwertew ", date : "4d", image: UIImage(named: "valak")),
        RepData(name : "Enforcer", desc : "terwtwertew ertwertwetdgsdfgsdf", date : "1d", image: UIImage(named: "valak")),
        RepData(name : "Enforcer", desc : "terwtwertew ", date : "4d", image: UIImage(named: "valak")),
        RepData(name : "Enforcer", desc : "terwtwertew ertwertwetdgsdfgsdf", date : "1d", image: UIImage(named: "valak")),
        RepData(name : "Enforcer", desc : "terwtwertew ", date : "4d", image: UIImage(named: "valak")),
        RepData(name : "Enforcer", desc : "terwtwertew ertwertwetdgsdfgsdf", date : "1d", image: UIImage(named: "valak")),
        RepData(name : "Enforcer", desc : "terwtwertew ", date : "4d", image: UIImage(named: "valak")),
        RepData(name : "Enforcer", desc : "terwtwertew ertwertwetdgsdfgsdf", date : "1d", image: UIImage(named: "valak")),
        RepData(name : "Enforcer", desc : "terwtwertew ", date : "4d", image: UIImage(named: "valak"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableContentCommit()
        configContent(with: model)
    }
    
    //MAKE: - Accept data from VC
    private func configContent(with model: Reposit?) {
        guard let model = model else { return }
        if let image = model.image {
            userImage.image = image
        }
        
        userLabel.text = model.name
        contentLabel.text = model.content
        descriptLabel.text = model.descript
        langLabel.text = model.lang
        forksLabel.text = "\(model.fork) forks"
        starsLabel.text = "\(model.star) stars"
    }
    
    func set(model: Reposit?) {
        self.model = model
    }
    
    //MAKE: - Announce Delegate & registering table
    private func configTableContentCommit() {
        tableContentCommit.delegate = self
        tableContentCommit.dataSource = self
        tableContentCommit.register(UINib(nibName: "ContentCommitTableViewCell", bundle: .main), forCellReuseIdentifier: "contCommit")
    }
    
    //MAKE: - Broadcast data to DetailCommitVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let commVC = segue.destination as? DetailCommitViewController {
            commVC.set(model: selectContCommit)
        }
    }
}

//MAKE: - Create table
extension ContentViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MAKE: - Create table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataRep.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "contCommit", for: indexPath) as? ContentCommitTableViewCell {
            cell.configContentCommit(model: dataRep[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    //MAKE: - Touch processing by table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectContCommit = dataRep[indexPath.row]
        performSegue(withIdentifier: "contCommVC", sender: self)
    }
}
    
