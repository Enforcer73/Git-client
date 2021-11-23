//
//  NetworkService.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 09.11.2021.
//

import Foundation

final class NetworkService {

    static let shared = NetworkService()
    
    private let reposUrl = "https://api.github.com/orgs/github/repos"
    private let commitsUrl = "https://api.github.com/repos/%@/commits"
    private let group = DispatchGroup()
    private init () {}

    //MARK: - Loading data GitDataRealm model
    func getGitReposAndCommtis(completion: @escaping ([GitDataRealm]?) -> Void) {
        guard let _reposUrl = URL(string: reposUrl) else { return }
        var gitDataRepoModels = [GitDataRealm]()
        getGitData(url: _reposUrl) { [weak self] data in
            guard let _self = self, let repos = data else { return }
            repos.forEach { repo in
                _self.group.enter()
                if let fullName = repo.fullName {
                    let _commitsUrl = String(format: _self.commitsUrl, fullName)
                    guard let url = URL(string: _commitsUrl) else { return }
                    _self.getCommitsData(url: url) { data in
                        guard let commits = data else { return }
                        let gitDataRepoModel = GitDataRealm(with: repo, commits: commits)
                        gitDataRepoModels.append(gitDataRepoModel)
                        _self.group.leave()
                    }
                }
            }
            _self.group.notify(queue: .main) { completion(gitDataRepoModels) }
        }
    }

    //MARK: - Loading data GitData model
    func getGitData(url: URL, completion: @escaping ([GitData]?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                let gitdata = try JSONDecoder().decode([GitData].self, from: data!)
                completion(gitdata)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }

    //MARK: - Loading data CommitData model
    func getCommitsData(url: URL, completion: @escaping ([CommitData]?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                let commitData = try JSONDecoder().decode([CommitData].self, from: data!)
                completion(commitData)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}
