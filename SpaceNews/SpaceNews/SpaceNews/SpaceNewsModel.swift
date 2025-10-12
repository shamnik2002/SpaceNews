//
//  SpaceNewsModel.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

/*
 {
     "count": 29889,
     "next": "https://api.spaceflightnewsapi.net/v4/articles/?limit=5&offset=5",
     "previous": null,
     "results": [
         {
             "id": 33481,
             "title": "Planet announces new line of satellites for daily Earth imaging",
             "authors": [
                 {
                     "name": "Jeff Foust",
                     "socials": {
                         "x": "https://x.com/jeff_foust",
                         "youtube": "",
                         "instagram": "",
                         "linkedin": "https://www.linkedin.com/in/jefffoust",
                         "mastodon": "https://mastodon.social/@jfoust",
                         "bluesky": "https://bsky.app/profile/jfoust.bsky.social"
                     }
                 }
             ],
             "url": "https://spacenews.com/planet-announces-new-line-of-satellites-for-daily-earth-imaging/",
             "image_url": "https://i0.wp.com/spacenews.com/wp-content/uploads/2025/10/planetowl.jpeg?fit=1024%2C576&ssl=1",
             "news_site": "SpaceNews",
             "summary": "\nPlanet has announced a new class of imaging satellites that will replace a line of spacecraft dating back to the company’s earliest days.\nThe post Planet announces new line of satellites for daily Earth imaging appeared first on SpaceNews.",
             "published_at": "2025-10-10T18:51:43Z",
             "updated_at": "2025-10-10T19:00:41.377591Z",
             "featured": false,
             "launches": [],
             "events": []
         }]}
 */
import Foundation
fileprivate let formatter = ISO8601DateFormatter()

struct SpaceNewsResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [SpaceNewsModel]?
}

struct SpaceNewsModel: Codable, Hashable {
    static func == (lhs: SpaceNewsModel, rhs: SpaceNewsModel) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: Int?
    let title: String?
//    let author: Author?
    let url: String?
    let image_url: String?
    let news_site: String?
    let summary: String?
    let published_at: String?
    var publishedDate: Date? {
        guard let published_at else { return nil }
        return formatter.date(from: published_at)
    }
    
//    struct Author: Codable {
//        let name: String?
//    }    
}
