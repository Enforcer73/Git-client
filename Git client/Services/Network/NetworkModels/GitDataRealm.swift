//
//  GitDataRealmModel.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 19.11.2021.
//

import Foundation
import RealmSwift

final class GitDataRealm: Object {

    @Persisted var id: String?
    @Persisted var isFavourite: Bool = false
    @Persisted var repo: GitData?
    @Persisted var commits: List<CommitData>

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience init(with model: GitData, commits: [CommitData]) {
        self.init()
        self.id = model.id
        self.repo = model
        if commits.count <= 10 {
            self.commits.append(objectsIn: commits)
        } else {
            let sliced = Array(commits.prefix(10))
            self.commits.append(objectsIn: sliced)
        }
    }
}
