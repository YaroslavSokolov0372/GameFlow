//
//  BracketsResketchView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 30/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct BracketsDomain: Reducer {
    
    struct State: Equatable {
        
        @BindingState var currentTab: BracketsType = .upper
        let liquiTeams: [LiquipediaSerie.LiquipediaTeam]
        let brackets: [PandascoreBrackets]
        let colors: [Color] = [Color.red, Color.green, Color.blue]
        var dragOffsetX: CGFloat = 0
        var focusedColumnIndex: Int = 0
        var offsetX: CGFloat {
            -CGFloat(focusedColumnIndex) * UIScreen.main.bounds.width + dragOffsetX
        }
        
         var numberOfColumns: Int {
             switch currentTab {
             case .upper:
                 return brackets.upperBrackets.keys.count
             case .lower:
                 return brackets.lowerBrackets.keys.count
             }
        }
    }
    
    enum BracketsType: CaseIterable {
        case upper
        case lower
        
        var index: Int {
            return BracketsType.allCases.firstIndex(of: self) ?? 0
        }
        
        var count: Int {
            return BracketsType.allCases.count - 1
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case updateCurrentOffsetX(DragGesture.Value)
        case handleDragEnded(DragGesture.Value, CGFloat)
        case moveToLeft
        case moveToRight
        case stayAtSameIndex
        case tabSelected(BracketsType)
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .tabSelected(let type):
                state.currentTab = type
                return .none
            case .updateCurrentOffsetX(let dragValue):
                state.dragOffsetX = dragValue.translation.width
                return .none
            case .handleDragEnded(let dragValue, let width):
                let isScrollingRight = state.dragOffsetX < 0
                let didScrollEnough = abs(dragValue.translation.width) > width * 0.5
                let isFirstColumn = state.focusedColumnIndex == 0
                let isLastColumn = state.focusedColumnIndex == state.numberOfColumns - 1
                return .run { send in
                    
                    if !didScrollEnough {
                        await send(.stayAtSameIndex, animation: .easeInOut)
                    }
                    if isScrollingRight, !isLastColumn {
                        await send(.moveToRight, animation: .easeInOut)
                    } else if !isScrollingRight, !isFirstColumn {
                        await send(.moveToLeft, animation: .easeInOut)
                    } else {
                        await send(.stayAtSameIndex, animation: .easeInOut)
                    }
                }
            case .moveToLeft:
                state.focusedColumnIndex -= 1
                state.dragOffsetX = 0
                return .none
            case .moveToRight:
                state.focusedColumnIndex += 1
                state.dragOffsetX = 0
                return .none
            case .stayAtSameIndex:
                state.dragOffsetX = 0
                return .none
            case .binding:
                return .none
//            default: return .none
            }
        }
        BindingReducer()
    }
}


struct BracketsView: View {
    
    var store: StoreOf<BracketsDomain>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geo in
                let width = geo.size.width
                
                ZStack {
                    
                    Color("Black", bundle: .main)
                        .ignoresSafeArea()
                    
                    
                    //MARK: - Header
                    VStack {
                        HStack {
                            
                            Text("Brackets")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .font(.gilroy(.bold, size: 18))
                                .frame(width: geo.size.width, alignment: .center)
                        }
                        .overlay {
                            HStack {
                                Button {
                                    dismiss()
                                } label: {
                                    Image("Arrow", bundle: .main)
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(.white)
                                        .rotationEffect(.degrees(180))
                                        .frame(width: 20, height: 17)
                                }
                                
                                Spacer()
                            }
                            .padding(.leading, 20)
                        }
                        .padding(.vertical, 15)
                        
                        if viewStore.brackets.lowerBrackets.isEmpty {
                            Text("TBD")
                                .foregroundStyle(.white)
                                .font(.gilroy(.medium, size: 20))
                            
                            
                            Spacer()
                        } else {
                            
                            if viewStore.currentTab == .lower {
                                VStack {
                                    ScrollView(.vertical) {
                                        ScrollView(.horizontal) {
                                            HStack(alignment: .top, spacing: 0) {
                                                ForEach(viewStore.brackets.lowerBrackets.sorted(by: {
                                                    $0.value.first!.begin_at?.ISOfotmattedString() ?? Date()
                                                    < $1.value.first!.begin_at?.ISOfotmattedString() ?? Date() }), id: \.key) { column in
                                                        VStack {
                                                            Text(column.key)
                                                                .font(.gilroy(.bold, size: 15))
                                                                .foregroundStyle(.white)
                                                                .frame(width: geo.size.width * 0.9)
                                                                .padding(.vertical, 15)
                                                                .background {
                                                                    RoundedRectangle(cornerRadius: 15)
                                                                        .foregroundStyle(Color("Gray", bundle: .main))
                                                                }
                                                                .padding(.top, 10)
                                                            
                                                            BracketsColumnCell(store: Store(
                                                                initialState: BracketsColumnCellDomain.State(
                                                                    liquiTeams: viewStore.liquiTeams,
                                                                    bracketsColumn: column.value
                                                                ), reducer: {
                                                                    BracketsColumnCellDomain()
                                                                }))
                                                            .frame(width: width)
                                                        }
                                                    }
                                            }
                                            .frame(width: CGFloat(viewStore.numberOfColumns) * width)
                                            .offset(x: viewStore.offsetX)
                                        }
                                        .frame(width: geo.size.width)
                                        .scrollIndicators(.never)
                                        .scrollDisabled(true)
                                        .gesture(DragGesture(minimumDistance: 12, coordinateSpace: .global)
                                            .onChanged({ value in
                                                self.store.send(.updateCurrentOffsetX(value))
                                            }).onEnded({ value in
                                                self.store.send(.handleDragEnded(value, width))
                                            }))
                                        .ignoresSafeArea()
                                    }
                                }
                                
                                .overlay(alignment: .bottomTrailing) {
                                    VStack(spacing: 0) {
                                        Button {
                                            self.store.send(.tabSelected(BracketsDomain.BracketsType.upper))
                                        } label: {
                                            Image("Arrow", bundle: .main)
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundStyle(.white)
                                                .rotationEffect(.degrees(270))
                                                .offset(y: -1)
                                                .frame(width: 30, height: 27)
                                                .padding(10)
                                                .background(
                                                    Circle()
                                                        .foregroundStyle(Color(viewStore.currentTab == .lower ? "Orange" : "Gray2", bundle: .main))
                                                )
                                                .padding(.trailing, 10)
                                                .padding(.bottom, 10)
                                            //                                                .disabled(type != viewStore.currentTab)
                                        }
                                        
                                        Button {
                                            self.store.send(.tabSelected(BracketsDomain.BracketsType.lower))
                                        } label: {
                                            Image("Arrow", bundle: .main)
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundStyle(.white)
                                                .rotationEffect(.degrees(90))
                                                .offset(y: 1)
                                                .frame(width: 30, height: 27)
                                                .padding(10)
                                                .background(
                                                    Circle()
                                                        .foregroundStyle(Color(viewStore.currentTab == .lower ? "Gray2" : "Orange", bundle: .main))
                                                )
                                                .padding(.trailing, 10)
                                                .padding(.bottom, 5)
                                            //                                                .disabled(type != viewStore.currentTab)
                                        }
                                    }
                                }
                            } else {
                                VStack {
                                    ScrollView(.vertical) {
                                        ScrollView(.horizontal) {
                                            HStack(alignment: .top, spacing: 0) {
                                                //                                            ForEach(viewStore.brackets.upperBrackets.sorted(by: { $0.key < $1.key }), id: \.key) { column in
                                                ForEach(viewStore.brackets.upperBrackets.sorted(by: {
                                                    $0.value.first!.begin_at?.ISOfotmattedString() ?? Date()
                                                    < $1.value.first!.begin_at?.ISOfotmattedString() ?? Date() }), id: \.key) { column in
                                                        
                                                        VStack {
                                                            Text(column.key)
                                                                .font(.gilroy(.bold, size: 15))
                                                                .foregroundStyle(.white)
                                                                .frame(width: geo.size.width * 0.9)
                                                                .padding(.vertical, 15)
                                                                .background {
                                                                    RoundedRectangle(cornerRadius: 15)
                                                                        .foregroundStyle(Color("Gray", bundle: .main))
                                                                }
                                                                .padding(.top, 10)
                                                            
                                                            BracketsColumnCell(store: Store(
                                                                initialState: BracketsColumnCellDomain.State(
                                                                    liquiTeams: viewStore.liquiTeams,
                                                                    bracketsColumn: column.value
                                                                ), reducer: {
                                                                    BracketsColumnCellDomain()
                                                                }))
                                                            .frame(width: width)
                                                        }
                                                    }
                                            }
                                            .frame(width: CGFloat(viewStore.numberOfColumns) * width)
                                            .offset(x: viewStore.offsetX)
                                        }
                                        .frame(width: geo.size.width)
                                        .scrollIndicators(.never)
                                        .scrollDisabled(true)
                                        .gesture(DragGesture(minimumDistance: 12, coordinateSpace: .global)
                                            .onChanged({ value in
                                                self.store.send(.updateCurrentOffsetX(value))
                                            }).onEnded({ value in
                                                self.store.send(.handleDragEnded(value, width))
                                            }))
                                        .ignoresSafeArea()
                                    }
                                }
                                .overlay(alignment: .bottomTrailing) {
                                    VStack(spacing: 0) {
                                        Button {
                                            self.store.send(.tabSelected(BracketsDomain.BracketsType.upper))
                                        } label: {
                                            Image("Arrow", bundle: .main)
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundStyle(.white)
                                                .rotationEffect(.degrees(270))
                                                .offset(y: -1)
                                                .frame(width: 30, height: 27)
                                                .padding(10)
                                                .background(
                                                    Circle()
                                                        .foregroundStyle(Color(viewStore.currentTab == .lower ? "Orange" : "Gray2", bundle: .main))
                                                )
                                                .padding(.trailing, 10)
                                                .padding(.bottom, 10)
                                            //                                                .disabled(type != viewStore.currentTab)
                                        }
                                        
                                        Button {
                                            self.store.send(.tabSelected(BracketsDomain.BracketsType.lower))
                                        } label: {
                                            Image("Arrow", bundle: .main)
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundStyle(.white)
                                                .rotationEffect(.degrees(90))
                                                .offset(y: 1)
                                                .frame(width: 30, height: 27)
                                                .padding(10)
                                                .background(
                                                    Circle()
                                                        .foregroundStyle(Color(viewStore.currentTab == .lower ? "Gray2" : "Orange", bundle: .main))
                                                )
                                                .padding(.trailing, 10)
                                                .padding(.bottom, 5)
                                            //                                                .disabled(type != viewStore.currentTab)
                                        }
                                    }
                                }
                            }
                        }
                        
//                        TabView(selection: viewStore.$currentTab, content:  {
//                            ForEach(BracketsResketchDomain.BracketsType.allCases, id: \.self) { type in
//                                VStack {
//                                    ScrollView(.vertical) {
//                                        ScrollView(.horizontal) {
//                                            HStack(alignment: .top, spacing: 0) {
//                                                switch viewStore.currentTab {
//                                                case .upper:
//                                                    ForEach(viewStore.brackets.upperBrackets.sorted(by: { $0.key < $1.key }), id: \.key) { column in
//                                                        VStack {
//                                                            Text(column.key)
//                                                            BracketsColumnCell(store: Store(
//                                                                initialState: BracketsColumnCellDomain.State(
//                                                                    bracketsColumn: column.value
//                                                                ), reducer: {
//                                                                    BracketsColumnCellDomain()
//                                                                }))
//                                                            .frame(width: width)
//                                                        }
//                                                    }
//                                                case .lower:
//                                                    ForEach(viewStore.brackets.lowerBrackets.sorted(by: { $0.key < $1.key }), id: \.key) { column in
//                                                        VStack {
//                                                            Text(column.key)
//                                                            
//                                                            BracketsColumnCell(store: Store(
//                                                                initialState: BracketsColumnCellDomain.State(
//                                                                    bracketsColumn: column.value
//                                                                ), reducer: {
//                                                                    BracketsColumnCellDomain()
//                                                                }))
//                                                            .frame(width: width)
//                                                            
//                                                        }
//                                                    }
//                                                }
//                                            }
//                                            .frame(width: CGFloat(viewStore.numberOfColumns) * width)
//                                            .offset(x: viewStore.offsetX)
//                                        }
//                                        .frame(width: geo.size.width)
//                                        .scrollIndicators(.never)
//                                        .scrollDisabled(true)
//                                        .gesture(DragGesture(minimumDistance: 12, coordinateSpace: .global)
//                                            .onChanged({ value in
//                                                self.store.send(.updateCurrentOffsetX(value))
//                                            }).onEnded({ value in
//                                                self.store.send(.handleDragEnded(value, width))
//                                            }))
//                                        .ignoresSafeArea()
//                                    }
//                                }
//                                .tag(type)
//                                .overlay(alignment: .bottomTrailing) {
//                                    VStack(spacing: 0) {
//                                        Button {
//                                            self.store.send(.tabSelected(BracketsResketchDomain.BracketsType.upper))
//                                        } label: {
//                                            Image("Arrow", bundle: .main)
//                                                .resizable()
//                                                .renderingMode(.template)
//                                                .foregroundStyle(.white)
//                                                .rotationEffect(.degrees(270))
//                                                .offset(y: -1)
//                                                .frame(width: 30, height: 27)
//                                                .padding(10)
//                                                .background(
//                                                    Circle()
//                                                        .foregroundStyle(Color(type == .lower ? "Orange" : "Gray2", bundle: .main))
//                                                )
//                                                .padding(.trailing, 10)
//                                                .padding(.bottom, 10)
////                                                .disabled(type != viewStore.currentTab)
//                                        }
//                                        
//                                        Button {
//                                            self.store.send(.tabSelected(BracketsResketchDomain.BracketsType.lower))
//                                        } label: {
//                                            Image("Arrow", bundle: .main)
//                                                .resizable()
//                                                .renderingMode(.template)
//                                                .foregroundStyle(.white)
//                                                .rotationEffect(.degrees(90))
//                                                .offset(y: 1)
//                                                .frame(width: 30, height: 27)
//                                                .padding(10)
//                                                .background(
//                                                    Circle()
//                                                        .foregroundStyle(Color(type == .lower ? "Gray2" : "Orange", bundle: .main))
//                                                )
//                                                .padding(.trailing, 10)
//                                                .padding(.bottom, 5)
////                                                .disabled(type != viewStore.currentTab)
//                                        }
//                                    }
//                                }
//                            }
//                        })
//                        .toolbar(.hidden, for: .tabBar)
//                        .ignoresSafeArea(edges: [.bottom])
                    }
                }
            }
        }
    }
}
//
//#Preview {
//    BracketsResketchView(store: Store(initialState: BracketsResketchDomain.State(), reducer: {
//        BracketsResketchDomain()
//    }))
//}
