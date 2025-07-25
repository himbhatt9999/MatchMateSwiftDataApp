//
//  HomeScreen.swift
//  MatchMateSwiftDataApp
//
//  Created by Him Bhatt on 25/07/25.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
    @StateObject private var viewModel = MatchMateViewModel()
    @Environment(\.modelContext) private var modelContext

    @State private var showToast = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    // Dropdown filter in the nav bar, not tabs
                    if viewModel.isLoading {
                        ProgressView("Loading profiles...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.pink.opacity(0.02))
                    } else if viewModel.profiles.isEmpty {
                        EmptyStateView(viewModel: viewModel, modelContext: modelContext)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.pink.opacity(0.02))
                    } else {
                        ProfileListView(viewModel: viewModel)
                            .background(.pink.opacity(0.02))
                    }
                }
                // Toast for offline, auto-hide
                if showToast {
                    ToastView(message: "You're offline. Showing cached profiles.")
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(10)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { showToast = false }
                            }
                        }
                }
            }
            .navigationTitle("MatchMate")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("All") {
                            viewModel.setFilter(status: nil)
                            viewModel.fetchLocal(context: modelContext)
                        }
                        Button("Accepted") {
                            viewModel.setFilter(status: .accepted)
                            viewModel.fetchLocal(context: modelContext)
                        }
                        Button("Declined") {
                            viewModel.setFilter(status: .declined)
                            viewModel.fetchLocal(context: modelContext)
                        }
                    } label: {
                        Label(viewModel.filter?.displayName ?? "All", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task { await viewModel.fetchProfiles(context: modelContext) }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .task {
                await viewModel.fetchProfiles(context: modelContext)
            }
            .onChange(of: viewModel.isConnected) { isConn in
                if !isConn {
                    withAnimation { showToast = true }
                }
            }
            .alert(isPresented: Binding(
                get: { viewModel.error != nil },
                set: { _ in viewModel.error = nil }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.error?.localizedDescription ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
