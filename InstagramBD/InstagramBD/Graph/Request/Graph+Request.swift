//
//  Graph+Request.swift
//  Created 7/15/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation
import CommonUtility

extension Graph {
    /// Encapsulates all token-based requests to the Graph API
    // includes functionalities such as token refresh, global-access re-tries, etc.
    struct Request {
        
        enum Constants {
            static let maxRetries: Int = 3
        }
        
        let user: InstaUser
        var session: URLSession
        
        init(user: InstaUser,
             session: URLSession = URLSession(configuration: .default)) {
            self.user = user
            self.session = session
        }
        
    }
    
}

extension Graph.Request {
    enum Endpoint {
    
        case username
        case refreshToken
        case media
        case mediaInfo(mediaId: String)
        
        func urlRequest(user: InstaUser) throws -> URLRequest {
            switch self {
            case .username:
                return try userNameRequest(user: user)
            case .refreshToken:
                return try refreshTokenRequest(user: user)
            case .media:
                return try mediaRequest(user: user)
            case .mediaInfo(let mediaId):
                return try mediaInfoRequest(user: user, mediaId: mediaId)
            }
        }
    }
}

extension Graph.Request.Endpoint {
    
    func mediaInfoRequest(user: InstaUser, mediaId: String) throws -> URLRequest {
        guard let token = user.token else {
            throw Graph.GraphError.noToken
        }
        let urlString = Graph.root
            + mediaId
            + "?fields=id,media_type,media_url,username,timestamp&access_token="
            + token
        guard let url = URL(string: urlString) else {
            throw Graph.GraphError.badUrl(urlString)
        }
        return URLRequest(url: url)
    }
    
    func mediaRequest(user: InstaUser) throws -> URLRequest {
        guard let token = user.token else {
            throw Graph.GraphError.noToken
        }
        let urlString = Graph.root
            + "me" // user.userId
            + "/media?fields=id,caption&access_token="
            + token
        guard let url = URL(string: urlString) else {
            throw Graph.GraphError.badUrl(urlString)
        }
        return URLRequest(url: url)
    }
    
    /// start a request to fetch a user's username
    func userNameRequest(user: InstaUser) throws -> URLRequest {
        guard let token = user.token else {
            throw Graph.GraphError.noToken
        }
        let urlString = Graph.root
            + "me" // user.userId
            + "?fields=id,username&access_token="
            + token
        guard let url = URL(string: urlString) else {
            throw Graph.GraphError.badUrl(urlString)
        }
        return URLRequest(url: url)
    }
    
    func refreshTokenRequest(user: InstaUser) throws -> URLRequest {
        fatalError("not implemented")
    }

}
    
extension Graph.Request {
    
    func request<Response: Decodable>(_ endpoint: Endpoint,
                                      _ completion: @escaping (Result<Response, Error>) -> Void) {
        let error = Graph.GraphError.unknown("broken behavior in request handler")
        let result: Result<Response, Error> = .failure(error)
        let opQueue = OperationQueue()
        let completionOperation = FinalizeOperation<Response>(result: result)
        completionOperation.completionBlock = {
            completion(completionOperation.result)
        }
        let requestOperation = RequestOperation(completionOperation,
                                                queue: opQueue,
                                                tries: Constants.maxRetries,
                                                endpoint: endpoint,
                                                result: result, request: self)
        opQueue.addOperation(requestOperation)
        opQueue.addOperation(completionOperation)
    }

}

extension Graph.Request {
    
    func userName(_ completion: @escaping (Result<String, Error>) -> Void) {
        request(.username) { (result: Result<Graph.Response.UserName, Error>) in
            switch result {
            case .success(let usernameResponse):
                completion(.success(usernameResponse.username))
            case .failure(let error):
                self.handle(error: error)
                completion(.failure(error))
            }
        }
    }
    
    func media(_ completion: @escaping (Result<[MediaInfo], Error>) -> Void) {
        request(.media) { (result: Result<Graph.Response.MediaContainer, Error>) in
            switch result {
            case .success(let mediaIds):
                let ids = mediaIds.data.map { $0.id }
                self.mediaHelper(ids: ids, completion: completion)
            case .failure(let error):
                self.handle(error: error)
                completion(.failure(error))
            }
        }
    }
    
    private func mediaHelper(ids: [String],
                             completion: @escaping (Result<[MediaInfo], Error>) -> Void) {
        let infos = ThreadsafeArray<MediaInfo?>(repeating: nil, count: ids.count)
        let group = DispatchGroup()
        for (i, mediaId) in ids.enumerated() {
            group.enter()
            self.request(.mediaInfo(mediaId: mediaId)) { (result: Result<MediaInfo, Error>) in
                if case .success(let mediaInfo) = result {
                    infos[i] = mediaInfo
                }
                group.leave()
            }
        }
        group.notify(queue: .global(qos: .userInitiated)) {
            completion(.success(infos.array.compactMap { $0 }))
        }
    }
    
}

extension Graph.Request {
    
    // handler functions.
    
    // MARK: TODO - Set up an error logger here
    func handle(error: Error) {
        switch error {
        case let graphError as Graph.GraphError:
            handle(error: graphError)
        default:
            print(error)
        }
    }
    
    func handle(error: Graph.GraphError) {
        switch error {
        case .expiredToken:
            print("token has expired-control flow should never reach this point.")
        default:
            print(error)
        }
    }
    
}
