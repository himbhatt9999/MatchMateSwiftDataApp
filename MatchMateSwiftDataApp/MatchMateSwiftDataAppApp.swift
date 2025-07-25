//
//  MatchMateSwiftDataAppApp.swift
//  MatchMateSwiftDataApp
//
//  Created by Him Bhatt on 25/07/25.
//

import SwiftUI
import SwiftData

@main
struct MatchMateSwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .modelContainer(for: [UserProfile.self])
        }
    }
}
