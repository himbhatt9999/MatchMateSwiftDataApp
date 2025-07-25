//
//  ApiService.swift
//  MatchMateSwiftDataApp
//
//  Created by Him Bhatt on 25/07/25.
//

import Foundation
import Alamofire

final class ApiService {
    static let shared = ApiService()
    private init() {}

    struct API {
        static let profilesEndpoint = "https://randomuser.me/api/?results=10"
    }

    // MARK: - Main fetch method
    func fetchProfiles() async throws -> [UserProfile] {
        let data = try await AF.request(API.profilesEndpoint)
            .validate()
            .serializingData()
            .value

        let apiResponse = try JSONDecoder().decode(RandomUserResponse.self, from: data)
        return apiResponse.results.map { $0.toUserProfile() }
    }
}

// MARK: - JSON Response Models (matching https://randomuser.me API)

private struct RandomUserResponse: Decodable {
    let results: [RandomUser]
}

private struct RandomUser: Decodable {
    struct Name: Decodable { let first, last: String }
    struct Login: Decodable { let uuid: String }
    struct DOB: Decodable { let age: Int }
    struct Picture: Decodable { let large: String }
    struct Location: Decodable { let city, country: String }
    let login: Login
    let name: Name
    let dob: DOB
    let gender: String
    let email: String
    let phone: String
    let nationality: String?
    let location: Location
    let picture: Picture

    func toUserProfile() -> UserProfile {
        UserProfile(
            id: login.uuid,
            name: "\(name.first) \(name.last)",
            age: dob.age,
            gender: gender.capitalized,
            email: email,
            phone: phone,
            nationality: nationality ?? "",
            location: "\(location.city), \(location.country)",
            pictureURL: picture.large,
            status: .new // Default to "new" on fetch
        )
    }
}
