//
//  ViewModel.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 09.11.2021.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    func dataDidReciveGitData(data: [GitData])
    func error()
}

class ViewModel {
    
    weak var delegate: ViewModelDelegate?
    
    func getGitData() {
        let gitUrl = URL(string: "https://api.github.com/orgs/github/repos")!
        NetworkService.shared.getGitData(url: gitUrl) {[weak self] commits in
            guard let commitsModels = commits else {
                self?.delegate?.error()
                return
            }
            
            self?.delegate?.dataDidReciveGitData(data: commitsModels)
        }
    }
}
