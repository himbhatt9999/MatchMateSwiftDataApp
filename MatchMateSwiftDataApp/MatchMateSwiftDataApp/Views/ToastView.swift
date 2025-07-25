//
//  ToastView.swift
//  MatchMateSwiftDataApp
//
//  Created by Him Bhatt on 25/07/25.
//

import SwiftUI

struct ToastView: View {
    let message: String
    var body: some View {
        HStack {
            Image(systemName: "wifi.slash")
            Text(message).font(.subheadline)
        }
        .foregroundColor(.white)
        .padding(12)
        .background(.orange.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 6)
        .frame(maxWidth: .infinity)
        .padding(.top, 50)
        .padding(.horizontal, 24)
    }
}
