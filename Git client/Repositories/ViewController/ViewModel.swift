//
//  ViewModel.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 09.11.2021.
//

import Foundation
import RealmSwift

protocol ViewModelDelegate: AnyObject {
    func dataDidReciveGitDataRealm(data: [GitDataRealm])
    func error()
}

final class ViewModel {

    private var model: GitData?
    weak var delegate: ViewModelDelegate?
    let localRealm = try! Realm()

    //MARK: - Fetch data from DB
    func fetchDataFromDataBase() -> [GitDataRealm] {
        let realmData = Array(localRealm.objects(GitDataRealm.self))
        guard !realmData.isEmpty else {
            return [GitDataRealm]()
        }
        return realmData
    }

    //MARK: - Requsting data from DB
    func getGitReposAndCommtis() {
        NetworkService.shared.getGitReposAndCommtis { [weak self] dataRealm in
            guard let realmModel = dataRealm else {
                self?.delegate?.error()
                return
            }
            let realmData = self?.fetchDataFromDataBase()
            realmData?.forEach({ model in
                if let repo = realmModel.firstIndex(where: { model.id == $0.id }) {
                    realmModel[repo].isFavourite = true
                }
            })
            self?.delegate?.dataDidReciveGitDataRealm(data: realmModel)
        }
    }
    
    //MARK: - Save repo to favorite
    func saveGitdataToDataBase(model: GitDataRealm) {
        DispatchQueue.main.async { [unowned self] in
            do {
                try self.localRealm.write {
                    self.localRealm.add(model, update: .modified)
                }
            } catch {
                print("Ошибка записи в бд")
            }
        }
    }

    //MARK: - Removal repo from favorite
    func removeFavoritToDataBase(model: GitDataRealm) {
        DispatchQueue.main.async { [unowned self] in
            do {
                try self.localRealm.write {
                    self.localRealm.delete(model)
                }
            } catch {
                print("Ошибка удаления из бд")
            }
        }
    }
}


