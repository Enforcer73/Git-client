//
//  GitModel.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 09.11.2021.
//

import Foundation
import UIKit

struct GitData: Codable {

    let name, updatedAt, avatarUrl, login, commits: String
    let description, language: String?
    let forksCount, stars: Int
    
    var updatedAtFormatted: String {
        return updatedAtFormatting()
    }
    
    enum RootKeys: String, CodingKey {
        case name, description, language, owner
        case forksCount = "forks_count"
        case stars = "stargazers_count"
        case updatedAt = "updated_at"
        case commits = "commits_url"
    }

    enum OwnerKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        name          = try rootContainer.decode(String.self, forKey: .name)
        description   = try? rootContainer.decode(String.self, forKey: .description)
        language      = try? rootContainer.decode(String.self, forKey: .language)
        updatedAt     = try rootContainer.decode(String.self, forKey: .updatedAt)
        commits       = try rootContainer.decode(String.self, forKey: .commits)
        forksCount    = try rootContainer.decode(Int.self, forKey: .forksCount)
        stars         = try rootContainer.decode(Int.self, forKey: .stars)

        let ownerContainer = try rootContainer.nestedContainer(keyedBy: OwnerKeys.self, forKey: .owner)
        login       = try ownerContainer.decode(String.self, forKey: .login)
        avatarUrl = try ownerContainer.decode(String.self, forKey: .avatarUrl)
    }
    
    private func updatedAtFormatting() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"

        if let date = dateFormatterGet.date(from: updatedAt) {
            return dateFormatterPrint.string(from: date)
        }
        return updatedAt
    }
}

