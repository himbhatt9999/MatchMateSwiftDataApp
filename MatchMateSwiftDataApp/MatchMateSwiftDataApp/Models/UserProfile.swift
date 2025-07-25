//
//  UserProfile.swift
//  MatchMateSwiftDataApp
//
//  Created by Him Bhatt on 25/07/25.
//
import Foundation
import SwiftData

enum ProfileStatus: String, Codable, CaseIterable {
    case new, accepted, declined
    
    var displayName: String {
        switch self {
        case .new: return "All"
        case .accepted: return "Accepted"
        case .declined: return "Declined"
        }
    }
}

@Model
final class UserProfile: Identifiable {
    @Attribute(.unique) var id: String
    var name: String
    var age: Int
    var gender: String
    var email: String
    var phone: String
    var nationality: String
    var location: String
    var pictureURL: String
    var status: ProfileStatus
    var createdAt: Date
    var syncedWithServer: Bool = false
    var picture: Data? // for local image caching if desired
    
    init(id: String, name: String, age: Int, gender: String, email: String, phone: String, nationality: String, location: String, pictureURL: String, status: ProfileStatus = .new, createdAt: Date = .init()) {
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
        self.email = email
        self.phone = phone
        self.nationality = nationality
        self.location = location
        self.pictureURL = pictureURL
        self.status = status
        self.createdAt = createdAt
    }
}
