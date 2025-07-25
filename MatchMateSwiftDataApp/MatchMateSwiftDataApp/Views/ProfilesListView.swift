//
//  MainListsView.swift
//  MatchMateSwiftDataApp
//
//  Created by Him Bhatt on 25/07/25.
//

import SwiftUI

struct ProfileListView: View {
    @ObservedObject var viewModel: MatchMateViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.profiles) { profile in
                    ProfileCardView(profile: profile, viewModel: viewModel)
                        .padding(.horizontal, 12)
                }
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
