//
//  EmptyStateView.swift
//  MatchMateSwiftDataApp
//
//  Created by Him Bhatt on 25/07/25.
//

import SwiftUI
import SwiftData

struct EmptyStateView: View {
    @ObservedObject var viewModel: MatchMateViewModel
    let modelContext: ModelContext
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 70))
                .foregroundColor(.gray)
            Text(emptyStateMessage)
                .font(.headline)
                .multilineTextAlignment(.center)
            Button("Refresh") {
                Task { await viewModel.fetchProfiles(context: modelContext) }
            }
            .fontWeight(.semibold)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
    var emptyStateMessage: String {
        switch viewModel.filter {
        case .accepted: return "You haven't accepted any profiles yet"
        case .declined: return "You haven't declined any profiles yet"
        default: return "No profiles available"
        }
    }
}
