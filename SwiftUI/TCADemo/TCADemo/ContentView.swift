//
//  ContentView.swift
//  CounterDemo
//
//  Created by Wang Wei on 2021/12/08.
//

import SwiftUI
import ComposableArchitecture

// ContentView 中，我们不直接操作 Counter，而是将它放在一个 Store 中。
//MARK: - Store 负责把 Counter (State) 和 Action 连接起来
struct Counter: Equatable {
    var count: Int = 0
}

enum CounterAction {
    case increment
    case decrement
    case reset
}

// MARK: - CounterEnvironment 让我们有机会为 reducer 提供自定义的运行环境，用来注入一些依赖。我们会把相关内容放到后面再解释
struct CounterEnvironment { }

// MARK: - Reducer 是函数式编程中的常见概念，顾名思意，它将多项内容进行合并，最后返回单个结果
let counterReducer = AnyReducer<Counter, CounterAction, CounterEnvironment> { state, action, _ in
    
    // MARK: - 只在 Reducer 中改变状态
    switch action {
    case .increment:
        state.count += 1
        return .none
    case .decrement:
        state.count -= 1
        return .none
    case .reset:
        state.count = 0
        return .none
    }
}.debug()

struct CounterView: View {
    
    // MARK: - Store 负责把 Counter (State) 和 Action 连接起来
    let store: Store<Counter, CounterAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    // MARK: - 发送消息，而非直接改变状态
                    Button("-") { viewStore.send(.decrement) }
                    Text("\(viewStore.count)")
                        .foregroundColor(colorOfCount(viewStore.count))
                    Button("+") { viewStore.send(.increment) }
                }
                Button("Reset") { viewStore.send(.reset) }
            }
        }
    }
    
    func colorOfCount(_ value: Int) -> Color? {
        if value == 0 { return nil }
        return value < 0 ? .red : .green
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//      CounterView(
//        store: Store(
//          initialState: Counter(),
//          reducer: counterReducer,
//          environment: CounterEnvironment())
//      )
//    }
//}
