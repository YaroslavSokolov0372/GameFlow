//
//  NoUpcomingMatchesView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 27/11/2023.
//

import SwiftUI

struct NoUpcomingMatchesView: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color("Gray", bundle: .main))
                    .frame(width: 370, height: 230)
                    .overlay(alignment: .center) {
                        Text("There are no matches left")
                            .font(.gilroy(.medium, size: 20))
                            .foregroundStyle(.white)
                    }
            }
        }
    }
}

#Preview {
    NoUpcomingMatchesView()
}
