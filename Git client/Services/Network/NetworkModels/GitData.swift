//
//  GitData.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 14.11.2021.
//

import Foundation
import RealmSwift


class GitData: Object, Codable {

    @Persisted var login: String?
    @Persisted var fullName: String?
    @Persisted var avatarUrl: String?
    @Persisted var updatedAt: String?
    @Persisted var nameRep: String?
    @Persisted var descript: String?
    @Persisted var language: String?
    @Persisted var forksCount: Int?
    @Persisted var stars: Int?
    @Persisted var id: String?

    var updatedAtFormatted: String {
        return updatedAtFormatting()
    }

    enum RootKeys: String, CodingKey {
        case id = "node_id"
        case nameRep = "name"
        case description = "description"
        case language = "language"
        case owner = "owner"
        case fullName = "full_name"
        case forksCount = "forks_count"
        case stars = "stargazers_count"
        case updatedAt = "updated_at"
    }
    
    enum OwnerKeys: String, CodingKey {
        case login = "login"
        case avatarUrl = "avatar_url"
    }

    //MAKE: - Decoding
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        fullName        = try? rootContainer.decodeIfPresent(String.self, forKey: .fullName)
        nameRep         = try? rootContainer.decodeIfPresent(String.self, forKey: .nameRep)
        descript        = try? rootContainer.decodeIfPresent(String.self, forKey: .description)
        language        = try? rootContainer.decodeIfPresent(String.self, forKey: .language)
        updatedAt       = try? rootContainer.decodeIfPresent(String.self, forKey: .updatedAt)
        forksCount      = try? rootContainer.decodeIfPresent(Int.self, forKey: .forksCount)
        stars           = try? rootContainer.decodeIfPresent(Int.self, forKey: .stars)
        id              = try? rootContainer.decodeIfPresent(String.self, forKey: .id)
        
        let ownerContainer = try rootContainer.nestedContainer(keyedBy: OwnerKeys.self, forKey: .owner)
        login           = try? ownerContainer.decodeIfPresent(String.self, forKey: .login)
        avatarUrl       = try? ownerContainer.decodeIfPresent(String.self, forKey: .avatarUrl)
    }

    override class func primaryKey() -> String? {
      return "id"
    }
    
    //MAKE: - Formatting date
    private func updatedAtFormatting() -> String {
        guard let atUpdate = updatedAt else { return ""}
        
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
