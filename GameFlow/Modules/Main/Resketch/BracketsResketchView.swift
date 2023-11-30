//
//  BracketsResketchView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 30/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct BracketsResketchDomain: Reducer {
    
    struct State: Equatable {
        let colors: [Color] = [Color.red, Color.green, Color.blue]
        var dragOffsetX: CGFloat = 0
        var focusedColumnIndex: Int = 0
        var offsetX: CGFloat {
            // TODO: Offset Calculation for current focused column
            -CGFloat(focusedColumnIndex) * UIScreen.main.bounds.width * 0.9 + dragOffsetX
        }
        
         var numberOfColumns: Int {
            return 5
        }
    }
    
    enum Action {
        case updateCurrentOffsetX(DragGesture.Value)
        case handleDragEnded(DragGesture.Value, CGFloat)
        case moveToLeft
        case moveToRight
        case stayAtSameIndex
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .updateCurrentOffsetX(let dragValue):
                state.dragOffsetX = dragValue.translation.width
                return .none
            case .handleDragEnded(let dragValue, let width):
                let isScrollingRight = state.dragOffsetX < 0
                let didScrollEnough = abs(dragValue.translation.width) > width * 0.5
                let isFirstColumn = state.focusedColumnIndex == 0
                let isLastColumn = state.focusedColumnIndex == state.numberOfColumns - 1
                return .run { send in
//                    if !didScrollEnough {
//                        await send(.stayAtSameIndex, animation: .easeInOut)
//                    }
                    
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
//            default: return .none
            }
        }
    }
}


struct BracketsResketchView: View {
    
    var store: StoreOf<BracketsResketchDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geo in
                let width = geo.size.width * 0.9
                
                ScrollView(.vertical) {
                    ScrollView(.horizontal) {
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(0..<5, id: \.hashValue) { num in
                               VStack {
                                    Text("\(num)")
                                       .foregroundStyle(.black)
                                    
                                    BracketsColumnCell(store: Store(initialState: BracketsColumnCellDomain.State(), reducer: {
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
        }
    }
    


    // 3
//    private func updateCurrentOffsetX(_ dragGestureValue: DragGesture.Value) {
//        dragOffsetX = dragGestureValue.translation.width
//    }
    // 4
//    private func handleDragEnded(_ gestureValue: DragGesture.Value) {
//        // TODO: Decide to stay at the same column, or snap to some other column.
//    }

//    private func moveToLeft() {
//        withAnimation {
//            focusedColumnIndex -= 1
//            dragOffsetX = 0
//        }
//    }

//    private func moveToRight() {
//        withAnimation {
//            focusedColumnIndex += 1
//            dragOffsetX = 0
//        }
//    }

//    private func stayAtSameIndex() {
//        withAnimation {
//            dragOffsetX = 0
//        }
//    }
}

#Preview {
    BracketsResketchView(store: Store(initialState: BracketsResketchDomain.State(), reducer: {
        BracketsResketchDomain()
    }))
}
