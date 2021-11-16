//
//  NetworkService.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 09.11.2021.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private init () {}
    
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
