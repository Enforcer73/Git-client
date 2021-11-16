//
//  FavoritesViewModel.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 16.11.2021.
//

import Foundation
import RealmSwift

protocol FavoritesViewModelDelegate: AnyObject {
    func dataDidReciveGitFromDataBase(data: [GitData])
    func dataDidReciveCommitFromDataBase(data: [CommitData])
    func error()
}

class FavoritesViewModel {
    
   
    private let viewModel = ViewModel()
    
    weak var delegate: FavoritesViewModelDelegate?
    
    
    //MAKE: - Get data from DB
    func fetchDataFromDataBase() {
        let gitData = Array(viewModel.localRealm.objects(GitData.self))
        
        guard !gitData.isEmpty else {
            return
        }
        
        delegate?.dataDidReciveGitFromDataBase(data: gitData)
    }
    
    func fetchCommitFromDataBase() {
        let commitData = Array(viewModel.localRealm.objects(CommitData.self))
        
        guard !commitData.isEmpty else {
            return
        }
        
        delegate?.dataDidReciveCommitFromDataBase(data: commitData)
    }
}

