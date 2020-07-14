//
//  Graph.swift
//  Created 7/10/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation

public enum Graph {
    static let root = "https://graph.instagram.com/"
}

extension Graph {
    struct Request {
        let user: InstaUser
    }
}

extension Graph.Request {
    /// does not work.
    func userName_urlRequest(_ completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = user.token else {
            completion(.failure(Graph.GraphError.noToken))
            return
        }
        let urlString = Graph.root
        guard let url = URL(string: urlString) else {
            completion(.failure(Graph.GraphError.badUrl(urlString)))
            return
            
        }
        var request = URLRequest(url: url)
        let body = [
            "fields": "id,username",
            "access_token": token
            ].urlEncoded()
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField:"Content-Type")
        request.setValue(String(body?.count ?? 0),
                         forHTTPHeaderField: "Content-Length")
        request.setValue("application/json",
                         forHTTPHeaderField:"Accept")
        request.httpBody = body
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            // TODO: - complete this once authorization is given
            completion(.success("Bob"))
        }.resume()
    }

    /// start a request to fetch a user's username
    func userName(_ completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = user.token else {
            completion(.failure(Graph.GraphError.noToken))
            return
        }
        let session = URLSession.shared
        let urlString = Graph.root
            + user.userId
            + "?fields=id,username&access_token="
            + token
        guard let url = URL(string: urlString) else {
            completion(.failure(Graph.GraphError.badUrl(urlString)))
            return
        }
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                // TODO: - change this error
                completion(.failure(Graph.GraphError.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let response =  try decoder.decode(UserNameResponse.self,
                                                   from: data)
                completion(.success(response.username))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}

struct UserNameResponse: Decodable {
    let id: String
    let username: String
}

public extension Graph {
    enum GraphError: Error {
        case noToken
        case noData
        case badUrl(String)
    }
}
