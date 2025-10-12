//
//  NewsStore.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//
import Foundation
import Combine

protocol CachePolicyProtocol {
    var expirationInterval: TimeInterval { get }
    var maxCapacity: Int { get }
}

struct CachePolicy: CachePolicyProtocol {
    var expirationInterval: TimeInterval = 60
    
    var maxCapacity: Int = 10
}

actor NewsCache {

    private var news: [String: [SpaceNewsModel]]
    private var cachePolicy: CachePolicyProtocol
    
    init(cachePolicy: CachePolicyProtocol) {
        self.cachePolicy = cachePolicy
        news = [:]
    }
    
    func getNews(category: String) -> [SpaceNewsModel]? {
        return news[category]
    }
    
    func saveNews(_ news:[SpaceNewsModel], category: String) {
        self.news[category] = news
    }
}

actor NewsStore {
               
    func saveToStore(news: [SpaceNewsModel], category: String) throws {
        guard let url = fileURL(category: category) else {return}
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(news)
            try data.write(to: url, options: [.atomic])
        }catch {
            // log error
            throw error
        }
    }
    
    func getFromStore(category: String) throws -> [SpaceNewsModel] {
        guard let url = fileURL(category: category) else {return []}
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: url)
            let news = try decoder.decode([SpaceNewsModel].self, from: data)
            return news
        } catch {
            throw error
        }
    }
    
    private func fileURL(category: String) -> URL? {
        let fileManager = FileManager.default
        guard let directory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        if !fileManager.fileExists(atPath: directory.path) {
            do {
                try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
            }catch {
                return nil
            }
        }
        let url = directory.appendingPathComponent("\(category).json")
        if !fileManager.fileExists(atPath: url.path) {
            fileManager.createFile(atPath: url.path, contents: nil)
        }
        return url
    }    
}
