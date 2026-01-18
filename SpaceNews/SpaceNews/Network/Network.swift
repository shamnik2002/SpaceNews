//
//  Network.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import Foundation
import Combine

protocol NetworkProtocol {
    func fetchDataWithPublisher(request: RequestProtocol) -> AnyPublisher<Data, Error>
}

struct NetworkService: NetworkProtocol {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchDataWithPublisher(request: RequestProtocol) -> AnyPublisher<Data, Error> {
        guard let urlRequest = try? request.buildRequest() else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        print
        return session.dataTaskPublisher(for: urlRequest)
                .tryMap{ result in
                    guard let httpResponse = result.response as? HTTPURLResponse else {
                        throw NetworkError.unknownError
                    }
                    
                    switch httpResponse.statusCode {
                        case 200...299:
                            return result.data
                        case 500...599:
                            throw NetworkError.serverError
                        case 403:
                            throw NetworkError.forbiddenError
                        case 401:
                            throw NetworkError.authError
                        default:
                            throw NetworkError.unknownError
                    }
                }.eraseToAnyPublisher()
    }
}

enum NetworkError: Error {
    case invalidURL
    case serverError
    case unknownError
    case forbiddenError
    case authError
}
