//
//  ContentModel.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 10.11.2021.
//

import Foundation

protocol ContentModelDelegate: AnyObject {
    func dataDidReciveGitData(data: [GitData])
    func error()
}

class ContentModel {
    
    weak var delegate: ContentModelDelegate?
    
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
