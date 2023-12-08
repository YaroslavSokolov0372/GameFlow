//
//  SearchField.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 31/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct SearchFieldDomain: Reducer {
    struct State: Equatable {
        
        @BindingState var searchText = ""
    }
    
    enum Action: BindableAction{
//     case textChanged(BindingAction<State>)
        case binding(BindingAction<State>)
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

            case .binding(_):
                return .none
            }
        }
        
        BindingReducer()
    }
}

struct SearchField: View {
    @FocusState var isFocused
    var store: StoreOf<SearchFieldDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white)
            
                TextField("Series", text: viewStore.$searchText)
                    .foregroundStyle(.white)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .font(.gilroy(.medium, size: 16))
                    .focused($isFocused)
                
                
                    Button {
                            isFocused = false
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.white)
                            .font(.gilroy(.medium, size: 16))
                    }
                    .offset(x: isFocused ? 0 : 80)
                    .opacity(isFocused ? 1 : 0)
                    .animation(.spring(response: 0.1, dampingFraction: 0.7), value: isFocused)
                    
                
                    
            }
            .padding()
            .frame(width: 370)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(Color("Gray", bundle: .main))
            )
        }
    }
}

#Preview {
    SearchField(store: Store(initialState: SearchFieldDomain.State(), reducer: {
        SearchFieldDomain()
    }))
}
