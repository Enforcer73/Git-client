//
//  RealmProvider.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 22.11.2021.
//

import Foundation
import RealmSwift

final class RealmProvider {

    static let shared = RealmProvider()

    let realm = try! Realm()

    func save(model: GitDataRealm) {
        DispatchQueue.main.async { [unowned self] in
            try! realm.write {
                realm.add(model, update: .modified)
                print("Realm save")
            }
        }
    }

    func delete(model: GitDataRealm) {
        DispatchQueue.main.async { [unowned self] in
            try! realm.write {
                realm.delete(model)
                print("Realm delete")
            }
        }
    }

    func fetchFavouritesRepos() -> [GitDataRealm] {
        let repos = realm.objects(GitDataRealm.self)
        print("Realm get repos")
        return Array(repos)
    }
}
