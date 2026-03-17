//
//  HabitItemView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/23.
//

import SwiftUI
import ComposableArchitecture

struct HabitItemView: View {
    private let habitStore: StoreOf<HabitFeature>
    private let habit: Habit
    
    let completionStore: StoreOf<CompletionFeature> = Store(initialState: CompletionFeature.State(), reducer: { CompletionFeature() })
    
    @State private var offset: CGFloat = 0
    @State private var slideRight = false
    @State private var slideLeft = false
    
    init(habitStore: StoreOf<HabitFeature>, habit: Habit) {
        self.habitStore = habitStore
        self.habit = habit
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            EditHabitView(
                habitStore: habitStore,
                statisticsStore: Store(initialState: StatisticsFeature.State(), reducer: { StatisticsFeature() }),
                habit: habit,
                offset: $offset
            )
            WithViewStore(habitStore, observe: { $0 }) { viewStore in
                WithViewStore(completionStore, observe: { $0 }) { completionViewStore in
                    if !habit.isInvalidated {
                        HStack {
                            habitContentView(weekDay: habit.weekString(), name: habit.name, continuity: habit.continuity)
                        }
                        .scaledFrame(width: .none, height: 80)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                        )
                        .scaledPadding(top: 0, leading: 16, bottom: 0, trailing: 16)
                        .opacity(completionViewStore.doneTodayMap[habit.id!] == true ? 0.5 : 1)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            slideLeft = false
                            slideRight = false
                            offset = 0
                        }
                        .offset(x: offset)
                        .simultaneousGesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
                    }
                }
            }
            
        }
    }
}

// MARK: - UI Components
extension HabitItemView {
    func habitContentView(weekDay: String, name: String, continuity: Int) -> some View {
        HStack {
            Text("\(weekDay)")
                .scaledText(size: 12, weight: .bold)
                .foregroundColor(Color.white)
                .padding(4)
                .background(Circle().fill(HabitColor.mediumGreen.color))
            
            Text(name)
                .scaledText(size: 20, weight: .semibold)
                .foregroundColor(Color(hex: "2E4A2B"))
            
            Spacer()
            
            Text("\(continuity)일")
                .scaledText(size: 20, weight: .semibold)
                .foregroundColor(HabitColor.darkGreen.color)
            
            Text("실천 중🔥")
                .scaledText(size: 20, weight: .medium)
                .foregroundColor(.gray.opacity(0.7))
        }
        .scaledPadding(top: 0, leading: 16, bottom: 0, trailing: 16)
    }
}

extension HabitItemView {
    func onChanged(value: DragGesture.Value) {
        //print("offset", value.translation.width)

        if value.translation.width < 0 {

            if (-value.translation.width < -UIScreen.main.bounds.width/2){
                offset = slideLeft ? value.translation.width - 60 : value.translation.width
            }
            else{
                offset = value.translation.width - 60
            }

        }
        else{

            if (value.translation.width < UIScreen.main.bounds.width/2){
                offset = slideRight ? value.translation.width + 110 : value.translation.width
            }
            else{
                offset =  UIScreen.main.bounds.width/2
            }

        }

    }

    func onEnd(value: DragGesture.Value){

        withAnimation(.easeOut){

            if value.translation.width < 0{
                if slideRight{
                    slideRight = false
                    offset = 0
                }

                else{
                    slideLeft = true
                    offset = -60
                }

            }
            else{
                if slideLeft{
                    slideLeft = false
                    offset = 0
                }
                else{
                    slideRight = true
                    offset = 110

                }
            }

        }
    }
}
