//
//  Commits.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 14.11.2021.
//

import Foundation
import RealmSwift


class CommitData: Object, Codable {

    @Persisted var message: String? = nil
    @Persisted var name: String? = nil
    @Persisted var date: String? = nil
    @Persisted var login: String? = nil
    @Persisted var id: String? = nil
    @Persisted var avatarUrl: String? = nil
    @Persisted var commitUrl: String? = nil

    var createdAtFormatted: String {
        return createdAtFormatting()
    }
    
    enum RootKeys: String, CodingKey {
        case commit = "commit"
        case committer = "committer"
        case id = "node_id"
        
    }

    enum CommitKeys: String, CodingKey {
        case author = "author"
        case message = "message"
        case commitUrl = "html_url"
    }

    enum CommitAuthorKeys: String, CodingKey {
        case date = "date"
        case name = "name"
    }

    enum CommitterKeys: String, CodingKey {
        case login = "login"
        case avatarUrl = "avatar_url"
    }

    
    //MAKE: - Decoding
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        id = try? rootContainer.decodeIfPresent(String.self, forKey: .id)

        let commitContainer = try rootContainer.nestedContainer(keyedBy: CommitKeys.self, forKey: .commit)
        message = try? commitContainer.decodeIfPresent(String.self, forKey: .message)

        let commitAuthorContainer = try commitContainer.nestedContainer(keyedBy: CommitAuthorKeys.self, forKey: .author)
        name = try? commitAuthorContainer.decodeIfPresent(String.self, forKey: .name)
        date = try? commitAuthorContainer.decodeIfPresent(String.self, forKey: .date)

        if let committerContainer = try? rootContainer.nestedContainer(keyedBy: CommitterKeys.self, forKey: .committer) {
            login = try? committerContainer.decodeIfPresent(String.self, forKey: .login)
            avatarUrl = try? committerContainer.decodeIfPresent(String.self, forKey: .avatarUrl)
        }
    }
    
    override class func primaryKey() -> String? {
      return "id"
    }
    
    //MAKE: - Formatting date
    private func createdAtFormatting() -> String {
        guard let atUpdate = date else { return ""}
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"

        if let date = dateFormatterGet.date(from: atUpdate) {
            return dateFormatterPrint.string(from: date)
        }
        return atUpdate
    }
}
