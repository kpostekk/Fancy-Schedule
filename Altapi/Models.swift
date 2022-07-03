//
//  Models.swift
//  Altapi
//
//  Created by Krystian Postek on 27/06/2022.
//

import Foundation

public struct AltapiEntry: Identifiable, Equatable, Codable {
    public var id: String {
        name + begin + end + type
    }
    
    public let name: String
    public let code: String
    public let room: String
    public let type: String
    public let begin: String
    public let end: String
    
    public init(name: String, code: String, type: String, begin: String, end: String, room: String = "unknown") {
        self.name = name
        self.code = code
        self.type = type
        self.begin = begin
        self.end = end
        self.room = room
    }
}

public struct AltapiEntryResponse: Codable {
    public let entries: [AltapiEntry]
}
