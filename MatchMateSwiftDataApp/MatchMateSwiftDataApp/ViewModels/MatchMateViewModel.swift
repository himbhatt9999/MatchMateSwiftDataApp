//
//  MatchMateViewModel.swift
//  MatchMateSwiftDataApp
//
//  Created by Him Bhatt on 25/07/25.
//
//
//import Foundation
//import SwiftData
//
//final class MatchMateViewModel: ObservableObject {
//    @Published var profiles: [UserProfile] = []
//    @Published var filter: ProfileStatus? = .new
//    @Published var isConnected: Bool = true
//    @Published var isLoading: Bool = false
//    @Published var error: Error? = nil
//
//    // Main async profile fetch (REMOTE + INSERT)
//    func fetchProfiles(context: ModelContext) async {
//        await MainActor.run { self.isLoading = true }
//        await MainActor.run { self.isLoading = false }
//
//        do {
//            let profiles = try await ApiService.shared.fetchProfiles()
//                for profile in profiles {
//                    if !self.profiles.contains(where: { $0.id == profile.id }) {
//                        context.insert(profile)
//                    }
//                }
//
//                try? context.save()
//            
//                await MainActor.run {
//                    self.isConnected = true
//                }
//                
//                self.fetchLocal(context: context)
//        } catch {
//            await MainActor.run {
//                self.isConnected = false
//                self.error = error
//            }
//            
//            self.fetchLocal(context: context)
//        }
//    }
//
//
//
//    // Fetch and filter locally (with #Predicate)
//    func fetchLocal(context: ModelContext) {
//        let desc: FetchDescriptor<UserProfile>
//        
//        if let filter = filter, filter != .new {
//            desc = FetchDescriptor(
//                predicate: #Predicate { $0.status == filter },
//                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
//            )
//        } else {
//            desc = FetchDescriptor(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
//        }
//        
//        do {
//            let localProfiles = try context.fetch(desc)
//            DispatchQueue.main.async {
//                self.profiles = localProfiles
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.profiles = []
//            }
//        }
//    }
//
//    // Accept/Decline/Reset profile
////    func updateProfileStatus(profile: UserProfile, status: ProfileStatus, context: ModelContext) {
////        profile.status = status
////        try? context.save()
////        fetchLocal(context: context)
////    }
//    
//    func updateProfileStatus(profile: UserProfile, status: ProfileStatus, context: ModelContext) {
//        profile.status = status
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save status: \(error)")
//        }
//        fetchLocal(context: context)
//    }
//
//    // Change and reapply the current filter
//    func setFilter(status: ProfileStatus?) {
//        filter = status
//    }
//}


import Foundation
import SwiftData

final class MatchMateViewModel: ObservableObject {
    @Published var profiles: [UserProfile] = []
    @Published var filter: ProfileStatus?
    @Published var isConnected: Bool = true
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil


    func fetchProfiles(context: ModelContext) async {
        await MainActor.run { self.isLoading = true }

        do {
            let fetchedUsers = try await ApiService.shared.fetchProfiles()
            
                for user in fetchedUsers {
                    if !self.profiles.contains(where: { $0.id == user.id }) {
                        let profile = UserProfile(
                            id: user.id,
                            name: user.name,
                            age: user.age,
                            gender: user.gender,
                            email: user.email,
                            phone: user.phone,
                            nationality: user.nationality,
                            location: user.location,
                            pictureURL: user.pictureURL,
                            status: .new
                        )
                        context.insert(profile)
                    }
                }
                try? context.save()
            DispatchQueue.main.async {
                self.isConnected = true
            }

            fetchLocal(context: context)
        } catch {
            await MainActor.run {
                self.isConnected = false
                self.error = error
            }
            fetchLocal(context: context)
        }

        await MainActor.run { self.isLoading = false }
    }

   
//    func fetchLocal(context: ModelContext)  {
//        
//        let descriptor = FetchDescriptor<UserProfile>()
//        do {
//            let dbProfiles = try context.fetch(descriptor)
//            DispatchQueue.main.async {
//                if let filterStatus = self.filter {
//                    self.profiles = dbProfiles.filter { $0.status == filterStatus }
//                } else {
//                    self.profiles = dbProfiles.filter { $0.status == .new }
//                }
//            }
//        } catch {
//            self.error = error
//        }
//    }
    
    func fetchLocal(context: ModelContext) {
        let descriptor = FetchDescriptor(sortBy: [SortDescriptor(\UserProfile.createdAt, order: .reverse)])
        do {
            let dbProfiles = try context.fetch(descriptor)
            DispatchQueue.main.async {
                if let filterStatus = self.filter {
                    self.profiles = dbProfiles.filter { $0.status == filterStatus }
                } else {
                    // Show all profiles regardless of status
                    self.profiles = dbProfiles
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.profiles = []
            }
        }
    }

    // Accept, decline, or reset a profile's status (always save on main thread)
    func updateProfileStatus(profile: UserProfile, status: ProfileStatus, context: ModelContext) {
        DispatchQueue.main.async {
            profile.status = status
            do {
                try context.save()
            } catch {
                print("Failed to save status: \(error)")
            }
        }
        fetchLocal(context: context)
    }

    // Change and reapply the current filter
    func setFilter(status: ProfileStatus?) {
        // No main thread needed as setFilter is called from UI events
        filter = status
    }
}
