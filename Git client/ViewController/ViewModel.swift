//
//  ViewModel.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 09.11.2021.
//

import Foundation
import RealmSwift

protocol ViewModelDelegate: AnyObject {
    func dataDidReciveGitData(data: [GitData])
    func dataDidReciveCommits(data: [CommitData])
    func error()
}


class ViewModel {
    
    
    weak var delegate: ViewModelDelegate?
    
    let localRealm = try! Realm()
    
    func printRealm() {
        let realmFact = Array(localRealm.objects(GitData.self))
        print("\(realmFact.count) шт")
    }
    
    
    //MAKE: - Requsting data from server
    func getGitData() {
        let gitUrl = URL(string: "https://Enforcer73:Sakura73RUS19740@api.github.com/orgs/github/repos")!
        NetworkService.shared.getGitData(url: gitUrl) { [weak self] datas in
            guard let datasModels = datas else {
                self?.delegate?.error()
                return
            }

            self?.delegate?.dataDidReciveGitData(data: datasModels)
        }
    }
    
    
    //MAKE: - Requsting commits from server
    func getCommitsData(fullName: String) {
        let commitUrl = "https://Enforcer73:Sakura73RUS19740@api.github.com/repos/%@/commits"
        let neededUrl = String(format: commitUrl, fullName)
        if let gitUrl = URL(string: neededUrl) {
            NetworkService.shared.getCommitsData(url: gitUrl) { [weak self] commits in
                guard let commitsModels = commits else {
                    self?.delegate?.error()
                    return
                }
                if commitsModels.count <= 10 {
                    self?.delegate?.dataDidReciveCommits(data: commitsModels)
                } else {
                    let sliced = Array(commitsModels.prefix(10))
                    self?.delegate?.dataDidReciveCommits(data: sliced)
                }
            }
        }  
    }
    
    
    //MAKE: - Save data to DB
    func saveGitdataToDataBase(model: [GitData]) {
        DispatchQueue.main.async {[weak self] in
            do {
                try self?.localRealm.write {
                    self?.localRealm.add(model, update: .modified)
                    print("\(model.count) GitData сохранено" )
                }
            } catch {
                print("database error")
            }
        }
    }
    
    func saveCommitsdataToDataBase(model: [CommitData]) {
        DispatchQueue.main.async {[weak self] in
            do {
                try self?.localRealm.write {
                    self?.localRealm.add(model, update: .modified)
                    print("\(model.count) Commit коммитов" )
                    
                }
            } catch {
                print("database error")
            }
        }
    }
}


