//
//  Parser.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import Foundation
import Combine

protocol ParseProtocol {
    func parse<T: Codable>(data: Data, type: T.Type) -> AnyPublisher<T, Error>
    func parseListData<T: Codable>(data: Data, type: T.Type) -> AnyPublisher<[T], Error>
}

struct Parser: ParseProtocol {
    
    func parse<T: Codable>(data: Data, type: T.Type) -> AnyPublisher<T, Error> {
        return Just(data)
            .tryMap { data in
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    return result
                }catch {
                    // log error
                    throw URLError(.cannotDecodeRawData)
                }
            }.eraseToAnyPublisher()
    }
    
    func parseListData<T: Codable>(data: Data, type: T.Type) -> AnyPublisher<[T], Error> {
        return Just(data)
            .tryMap { data in
                do {
                    let result = try JSONDecoder().decode([T].self, from: data)
                    return result
                }catch {
                    // log error
                    throw URLError(.cannotDecodeRawData)
                }
            }.eraseToAnyPublisher()
    }

}
