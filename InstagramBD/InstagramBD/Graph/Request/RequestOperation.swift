//
//  RequestOperation.swift
//  Created 7/16/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation
import CommonUtility

extension Graph.Request {
    
    class RequestOperation<Response: Decodable>: NWMOperation {
        
        let onFinish: FinalizeOperation<Response>
        let queue: OperationQueue
        let maxTries: Int
        let currentTry: Int
        let endpoint: Endpoint
        var result: Result<Response, Error>
        let request: Graph.Request
        
        // MARK: - Initializer
        
        private init(_ onFinish: FinalizeOperation<Response>,
                     queue: OperationQueue,
                     tries: Int, currentTry: Int = 0,
                     endpoint: Endpoint, result: Result<Response, Error>,
                     request: Graph.Request) {
            self.onFinish = onFinish
            self.queue = queue
            self.maxTries = tries
            self.currentTry = currentTry
            self.endpoint = endpoint
            self.result = result
            self.request = request
            super.init()
            onFinish.addDependency(self)
            self.isDebuggingEnabled = true
            self._isReady = true
        }
        
        convenience init(_ onFinish: FinalizeOperation<Response>,
                         queue: OperationQueue,
                         tries: Int, endpoint: Endpoint,
                         result: Result<Response,Error>,
                         request: Graph.Request) {
            self.init(onFinish, queue: queue,
                      tries: tries, currentTry: 0,
                      endpoint: endpoint, result: result,
                      request: request)
        }
        
        deinit {
            print("Did destroy operation")
        }
        
        func makeURLRequest() -> URLRequest? {
            let urlRequest: URLRequest?
            do {
                urlRequest = try endpoint.urlRequest(user: self.request.user)
            } catch {
                result = .failure(error)
                urlRequest = nil
            }
            return urlRequest
        }
        
        override func start() {
            if isDebuggingEnabled {
                print("Started Operation with count: \(currentTry)")
            }
            guard let urlRequest = makeURLRequest() else {
                self.finish()
                return
            }
            
            request.session.dataTask(with: urlRequest) { [weak self] data, response, error in
                let result: Result<Response,Error>
                defer {
                    self?.finalizeOperation(with: result)
                }
                print(data)
                print(response)
                print(error)
                print(try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves))
                if let error = error {
                    result = .failure(error)
                    return
                }
                guard let data = data else {
                    result = .failure(Graph.GraphError.noData)
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(Response.self, from: data)
                    result = .success(response)
                } catch {
                    do {
                        let failureResponse = try decoder.decode(Graph.RequestFailure.self,
                                                                 from: data)
                        let error = Graph.GraphError(response: failureResponse)
                        result = .failure(error)
                    }
                    catch {
                        result = .failure(error)
                    }
                }
            }.resume()
            super.start()
        }
        
        override func finish() {
            onFinish.result = result
            super.finish()
        }
        
        func nextOperation() -> RequestOperation? {
            let nextTryCount = currentTry + 1
            if nextTryCount >= maxTries {
                return nil
            }
            return RequestOperation(onFinish, queue: queue,
                                    tries: maxTries, currentTry: nextTryCount,
                                    endpoint: endpoint, result: result,
                                    request: request)
            
        }
        
        func finalizeOperation(with result: Result<Response,Error>) {
            // set the new result value
            self.result = result
            
            // do additional handling if there is a failure
            if case .failure(let resultFailure) = result,
                let tokenFailure = resultFailure as? Graph.GraphError {
                if case Graph.GraphError.expiredToken = tokenFailure {
                    print("TODO: - refresh token operation")
                    // if no refresh, prepare next operation
                    // queue.addOperation(RefreshTokenOperation())
                } else if let copy = nextOperation() {
                    queue.addOperation(copy)
                }
            }
            // always finalize the operation after downloading is completed
            finish()
        }
    }
    
    /// todo.
    class RefreshTokenOperation: Operation {
    
    }
    
    class FinalizeOperation<Response: Decodable>: Operation {
        var result: Result<Response, Error>
        
        init(result: Result<Response, Error>) {
            self.result = result
        }
    }
    
}

