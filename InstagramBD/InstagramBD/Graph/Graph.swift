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

/// Represents the `graph.instagram.com` endpoints.
public enum Graph {
    static let root = "https://graph.instagram.com/"
}

extension Graph {
    struct Request {
        let user: InstaUser
        let session: URLSession
        
        init(user: InstaUser,
             session: URLSession = URLSession(configuration: .default)) {
            self.user = user
            self.session = session
        }
    }
}

extension Graph.Request {

    /// start a request to fetch a user's username
    func userName(_ completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = user.token else {
            completion(.failure(Graph.GraphError.noToken))
            return
        }
        let urlString = Graph.root
            + "me" // user.userId
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
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(UserNameResponse.self,
                                                   from: data)
                completion(.success(response.username))
            } catch {
                do {
                    let response = try decoder.decode(ErrorResponse.self,
                                                   from: data)
                    completion(.failure(Graph.GraphError(response: response)))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
}

struct UserNameResponse: Decodable {
    let id: String
    let username: String
}

struct ErrorResponse: Decodable {
    let error: ErrorDetails
}

struct ErrorDetails: Decodable {
    let message: String
    let type: String
    let code: Int
    let fbTraceId: String
    
    enum CodingKeys: String, CodingKey {
        case message, type, code
        case fbTraceId = "fbtrace_id"
    }
}

public extension Graph {
    enum GraphError: Error {
        case noToken
        case noData
        case badUrl(String)
        case expiredToken
        case unknown
        
        init(response: ErrorResponse) {
            switch response.error.code {
            case 190:
                self = .expiredToken
            default:
                self = .unknown
            }
        }
    }
}
