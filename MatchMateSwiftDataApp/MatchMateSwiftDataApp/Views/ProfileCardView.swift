//
//  ProfileCardView.swift
//  MatchMateSwiftDataApp
//
//  Created by Him Bhatt on 25/07/25.
//

import SwiftUI
import SwiftData
import SDWebImageSwiftUI

struct ProfileCardView: View {
    let profile: UserProfile
    @ObservedObject var viewModel: MatchMateViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Profile picture (uses SDWebImageSwiftUI)
            WebImage(url: URL(string: profile.pictureURL)) { image in
                image.resizable()
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .overlay(Image(systemName: "person.fill").font(.largeTitle).foregroundColor(.gray))
            }
            .aspectRatio(contentMode: .fill)
            .frame(height: 200)
            .clipped()
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 8) {
                Text(profile.name)
                    .font(.title3)
                    .fontWeight(.bold)
                HStack(spacing: 6) {
                    Text("\(profile.age) years")
                    Text("•")
                    Text(profile.gender)
                    if !profile.nationality.isEmpty {
                        Text("•")
                        Text(profile.nationality)
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                Text(profile.location)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Action buttons
            if profile.status == .new {
                HStack(spacing: 10) {
                    Button(action: {
                        viewModel.updateProfileStatus(profile: profile, status: .declined, context: modelContext)
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Decline")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.red, lineWidth: 1))

                    Button(action: {
                        viewModel.updateProfileStatus(profile: profile, status: .accepted, context: modelContext)
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Accept")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green, lineWidth: 1))
                }
            } else {
                // Show bottom banner with status for accepted or declined profiles
                   HStack {
                       Spacer()
                       Text(profile.status == .accepted ? "Profile Accepted" : "Profile Declined")
                           .font(.subheadline.bold())
                           .foregroundColor(.white)
                           .padding(.horizontal, 12)
                           .padding(.vertical, 6)
                           .cornerRadius(4)
                       Spacer()
                   }
                   .padding(.top, 8)
                   .frame(maxWidth: .infinity)
                   .background(profile.status == .accepted ? Color.green : Color.red)
                   
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.pink.opacity(0.13), radius: 5, x: 0, y: 2)
    }
}
