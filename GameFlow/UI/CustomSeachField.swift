//
//  CustomSeachField.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 09/10/2023.
//

import SwiftUI

struct CustomSeachField: View {
    
    @FocusState var isSearchFocused: Bool
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
//                .foregroundStyle(.white)
                .foregroundStyle(.gameListCellForeground)
                .padding(.trailing, 5)
            
            TextField("Games", text: $text)
                .foregroundStyle(.white)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .focused($isSearchFocused)
            
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width / 1.05, height: 50)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.searchBack)
        )
        .padding(.horizontal)
        .overlay {
            ZStack {
                Rectangle()
                    .fill(.gameListCellForeground)
                    .frame(width: 100, height: 50)
                    .clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 10, topTrailingRadius: 10))
                    .animation(.spring(response: 0.4, dampingFraction: 1.0), value: isSearchFocused)
                
                Button {
                    isSearchFocused = false
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.searchBack)
                }
                .padding()
            }
            .offset(x: isSearchFocused ? 140 : 300)

        }
    }
}

#Preview {
    CustomSeachField(text: .constant(""))
}
