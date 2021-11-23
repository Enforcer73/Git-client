//
//  FavoritesViewModel.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 16.11.2021.
//

import Foundation
import RealmSwift

protocol FavoritesViewModelDelegate: AnyObject {
    func dataDidReciveDataFromDataBase(data: [GitDataRealm])
    func error()
}

final class FavoritesViewModel {
    
    private let viewModel = ViewModel()
    var favModels: [GitDataRealm]
    weak var delegate: FavoritesViewModelDelegate?

    init() {
        favModels = RealmProvider.shared.fetchFavouritesRepos()
    }
    
    //MARK: - Working with database
    func modelsCount() -> Int { favModels.count }

    func get(model: Int) -> GitDataRealm { favModels[model] }

    func updateData() {
        favModels = RealmProvider.shared.fetchFavouritesRepos()
    }

    //MARK: - Get data from DB
    func fetchDataFromDataBase() {
        let realmData = Array(viewModel.localRealm.objects(GitDataRealm.self))
        guard !realmData.isEmpty else {
            return
        }
        delegate?.dataDidReciveDataFromDataBase(data: realmData)
    }
}

