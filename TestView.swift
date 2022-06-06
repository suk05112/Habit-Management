//
//  TestView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/31.
//

import Foundation
import SwiftUI

struct TestView: View{
    
    @State var index: Int = 0
    @State var timer = Timer.publish(every: 2, on: RunLoop.main, in: RunLoop.Mode.common).autoconnect()
    var colors: [Color] = [Color.red, Color.blue, Color.green, Color.orange, Color.purple]
    var str = ["1111111111", "2222222222", "33333333", "4444444"]
    @State var transitionView: Bool = false
    @State var degrees = 0.0

    
    var body: some View {
        ZStack {
            ForEach(colors.indices) { i in
                if index == i {
                    colors[i]
                        .transition(.cubeRotation)
                }
            }
            
        }
        .frame(width: 200, height: 200, alignment: .center)
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 1.3)) {
                index = (index + 1) % colors.count
            }
        }
        
        /*
        ZStack(alignment: .bottom) {
            
            VStack{
                Button("버튼") {
                    transitionView.toggle()
                }
                Spacer()
            }
        if transitionView {
            RoundedRectangle(cornerRadius: 20)
                .frame(height: UIScreen.main.bounds.height * 0.5)
                .transition(.slide)
                .animation(.easeIn)
                
            }
        }
        */
            
        /*
        ZStack {
            ForEach(str.indices) { i in
                if index == i {
                    
                    ZStack{
                        colors[i]
                        VStack{
                            Text("\(str[i])")
                            .font(.system(size: 25))
                            Text("\(str[i])")
                            .font(.system(size: 25))
                        }
                    }
                    
                    .transition(.myslide)
                }
            }
            
        }

        .frame(width: .none, height: 40, alignment: .center)
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 1.3)) {
                index = (index + 1) % colors.count
                
            }
        }
        

        */
    }
}

struct CubeRotationModifier: AnimatableModifier {
    
    enum SlideDirection {
        case enter
        case exit
    }
    
    var pct: Double
    var direction: SlideDirection
    var h:CGFloat = 130

    var animatableData: Double {
        get { pct }
        set { pct = newValue }
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .rotation3DEffect(
                    Angle(degrees: calcRotation()),
                    axis: (x: 1.0, y: 0.0, z: 0.01),
                    anchor: direction == .enter ? .leading : .trailing,
                    anchorZ: 0,
                    perspective: 0.0
                )
                .transformEffect(.init(translationX: 0, y: calcTranslation(geo: geo, h: h)))

        }
    }
    
    func calcRotation() -> Double {
        if direction == .enter {
            return 90 - (pct * 90)
        } else {
            return -1 * (pct * 90)
        }
    }
    
    func calcTranslation(geo: GeometryProxy, h: CGFloat) -> CGFloat {
        if direction == .enter {
            return -geo.size.height + (CGFloat(pct) * geo.size.height)
        } else {
            return (CGFloat(pct) * geo.size.height)
        }
//        if direction == .enter {
//            return -h + (CGFloat(pct) * h)
//        } else {
//            return (CGFloat(pct) * h)
//        }

    }
}

extension AnyTransition {
    static var cubeRotation: AnyTransition {
        get {
            AnyTransition.asymmetric(
                insertion: AnyTransition.modifier(active: CubeRotationModifier(pct: 1, direction: .exit), identity: CubeRotationModifier(pct: 0, direction: .exit)),
                removal: AnyTransition.modifier(active: CubeRotationModifier(pct: 0, direction: .enter), identity: CubeRotationModifier(pct: 1, direction: .enter)).combined(with: AnyTransition.opacity))
        }

        
    }
}



extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .top))}
}

extension AnyTransition {
    static var myslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .bottom),
            removal: AnyTransition.opacity.animation(.easeIn(duration: 1)))}

}

struct MyPreviews: PreviewProvider {
    static var previews: some View {
        TestView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


