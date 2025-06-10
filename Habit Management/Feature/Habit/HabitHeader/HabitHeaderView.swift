//
//  HabitHeaderView.swift
//  Habit Management
//
//  Created by 서충원 on 6/9/25.
//

import SwiftUI
import ComposableArchitecture

struct HabitHeaderView: View {
    let setting: Setting
    let store: StoreOf<HabitHeaderFeature>
    
    init(store: StoreOf<HabitHeaderFeature>) {
        self.setting = Setting()
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in  // 다시 전체 State를 observe
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(viewStore.userName)님!")  // userName 프로퍼티 직접 접근
                        .habitHeaderStyle()
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .task {
                print("task 시작")
                await viewStore.send(.onAppear).finish()
                print("task 완료")
            }
            .environmentObject(setting)
        }
    }
}

extension Text {
    func habitHeaderStyle() -> some View {
        self.scaledText(size: 25, weight: .semibold)
    }
}
