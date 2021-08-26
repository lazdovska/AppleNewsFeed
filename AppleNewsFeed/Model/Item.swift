//
//  Item.swift
//  AppleNewsFeed
//
//  Created by kristine.lazdovska on 09/08/2021.
//

import Foundation

// MARK: - Marvel
struct Marvel: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let offset, limit, total, count: Int?
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let id: Int?
    let name, resultDescription: String?
    let thumbnail: Thumbnail?
    let resourceURI: String?
    let comics, series: Comics?
    let stories: Stories?
    let events: Comics?
    let urls: [URLElement]?
   

    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription = "description"
        case thumbnail, resourceURI, comics, series, stories, events, urls
    }
}

// MARK: - Comics
struct Comics: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [ComicsItem]?
    let returned: Int?
}

// MARK: - ComicsItem
struct ComicsItem: Codable {
    let resourceURI: String?
    let name: String?
}

// MARK: - Stories
struct Stories: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [StoriesItem]?
    let returned: Int?
}

// MARK: - StoriesItem
struct StoriesItem: Codable {
    let resourceURI: String?
    let name: String?
    let type: TypeEnum?
}

enum TypeEnum: String, Codable {
    case cover = "cover"
    case interiorStory = "interiorStory"
    case letters = "letters"
    case pinup = "pinup"
    case empty = ""
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String?
    let thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: String?
    let url: String?
}
