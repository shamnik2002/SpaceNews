//
//  SpaceNewsRequest.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

//https://api.spaceflightnewsapi.net/v4/articles/?limit=5

import Foundation

struct SpaceNewsRequest: RequestProtocol {
    var scheme: Scheme = .https
    
    var httpMethod: HttpMethod = .get
    
    var host: String = "api.spaceflightnewsapi.net"
    
    var path: String = "/v4/articles/"
    
    var headers: [String : String] = [:]
    
    var queryItems: [String : String]?
    
    var body: Data?
    
    init(limit: Int = 5, offset: Int = 0) {
        self.queryItems = ["limit": "\(limit)", "offset": "\(offset)"]
    }
    
    func buildRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        if let queryItems = queryItems {
            components.queryItems = queryItems.map{URLQueryItem(name: $0.key, value: $0.value)}
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        return request
    }
    
    
}

