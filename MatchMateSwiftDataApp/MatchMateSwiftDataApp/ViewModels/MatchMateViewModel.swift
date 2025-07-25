//
//  MatchMateViewModel.swift
//  MatchMateSwiftDataApp
//
//  Created by Him Bhatt on 25/07/25.
//

import Foundation
import SwiftData

final class MatchMateViewModel: ObservableObject {
    @Published var profiles: [UserProfile] = []
    @Published var filter: ProfileStatus? = nil
    @Published var isConnected: Bool = true
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil

    // Main async profile fetch (REMOTE + INSERT)
    func fetchProfiles(context: ModelContext) async {
        await MainActor.run { self.isLoading = true }
        await MainActor.run { self.isLoading = false }

        do {
            let profiles = try await ApiService.shared.fetchProfiles()
                for profile in profiles {
                    if !self.profiles.contains(where: { $0.id == profile.id }) {
                        context.insert(profile)
                    }
                }

                try? context.save()
            
                await MainActor.run {
                    self.isConnected = true
                }
                
                self.fetchLocal(context: context)
        } catch {
            await MainActor.run {
                self.isConnected = false
                self.error = error
            }
            
            self.fetchLocal(context: context)
        }
    }



    // Fetch and filter locally (with #Predicate)
    func fetchLocal(context: ModelContext) {
        let desc: FetchDescriptor<UserProfile>
        if let filter = filter, filter != .new {
            desc = FetchDescriptor(
                predicate: #Predicate { $0.status == filter },
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
        } else {
            desc = FetchDescriptor(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        }
        do {
            let localProfiles = try context.fetch(desc)
            DispatchQueue.main.async {
                self.profiles = localProfiles
            }
        } catch {
            DispatchQueue.main.async {
                self.profiles = []
            }
        }
    }

    // Accept/Decline/Reset profile
    func updateProfileStatus(profile: UserProfile, status: ProfileStatus, context: ModelContext) {
        profile.status = status
        try? context.save()
        fetchLocal(context: context)
    }

    // Change and reapply the current filter
    func setFilter(status: ProfileStatus?) {
        filter = status
    }
}
