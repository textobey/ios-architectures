//
//  ApodModel.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/07/10.
//

import Foundation

public struct ApodModel: Codable, Equatable, Identifiable, Hashable {
    public var id: String {
        url
    }
    
    public let favorite: Bool
    public let date: Date
    public let explanation: String
    public let hdurl: String?
    public let media_type: MediaType
    public let service_version: String
    public let title: String
    public let url: String

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = try container.decode(Date.self, forKey: CodingKeys.date)
        explanation = try container.decode(String.self, forKey: CodingKeys.explanation)
        hdurl = try container.decodeIfPresent(String.self, forKey: CodingKeys.hdurl)
        media_type = try container.decode(MediaType.self, forKey: CodingKeys.media_type)
        service_version = try container.decode(String.self, forKey: CodingKeys.service_version)
        title = try container.decode(String.self, forKey: CodingKeys.title)
        url = try container.decode(String.self, forKey: CodingKeys.url)
        favorite = false
    }

    public init(
        date: Date,
        explanation: String,
        hdurl: String?,
        media_type: MediaType,
        service_version: String,
        title: String,
        url: String,
        favorite: Bool
    ) {
        self.favorite = favorite
        self.date = date
        self.explanation = explanation
        self.hdurl = hdurl
        self.service_version = service_version
        self.media_type = media_type
        self.title = title
        self.url = url
    }
    
    public enum MediaType: String, Codable {
        case image
        case video
    }

    enum CodingKeys: String, CodingKey {
        case date
        case explanation
        case hdurl
        case media_type
        case service_version
        case title
        case url
    }
}
