/**
 *  ActionSheetCard
 *
 *  Copyright (c) 2021 Mahmud Ahsan. Licensed under the MIT license, as follows:
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import SwiftUI
import Combine

public struct ActionSheetCard: View {
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 10)

    @State var offset = UIScreen.main.bounds.height
    @Binding var isShowing: Bool
    @State var isDragging = false
    
    let heightToDisappear = UIScreen.main.bounds.height
    let backgroundColor: Color
    let outOfFocusOpacity: CGFloat
    let itemsSpacing: CGFloat
    let addView: AddView
    @State var height: CGFloat
    
    public init(
        isShowing: Binding<Bool>,
        backgroundColor: Color = Color.white,
        outOfFocusOpacity: CGFloat = 0.7,
        minimumDragDistanceToHide: CGFloat = 150,
        itemsSpacing: CGFloat = 0,
        addView: AddView
    ) {
        _isShowing = isShowing
        self.backgroundColor = backgroundColor
        self.outOfFocusOpacity = outOfFocusOpacity
        self.itemsSpacing = itemsSpacing
        self.addView = addView
        self.height = 300
    }
    
        
    var topHalfMiddleBar: some View {
        Capsule()
            .frame(width: 36, height: 5)
            .foregroundColor(Color.black)
            .padding(.vertical, 5.5)
            .opacity(0.2)
    }
    
    var itemsView: some View {
        VStack{
            addView
                .onAppear { self.kGuardian.addObserver() }
                .onDisappear { self.kGuardian.removeObserver() }
//            Text("ss")
//            Text("ss")
//            Text("ss")
//            Text("ss")
//            Text("ss")
//            Text("ss")
//            Text("ss")
                


        }
        
    }
    
    var outOfFocusArea: some View {
        Group {
            if isShowing {
                GreyOutOfFocusView(opacity: outOfFocusOpacity) {
                    self.isShowing = false
                }
            }
        }
    }
    
    var sheetView: some View {
        VStack {
            Spacer()
            
            VStack {
                topHalfMiddleBar
                itemsView
                   
                Text("").frame(height: 20) // empty space
            }
            .background(backgroundColor)
            .cornerRadius(15)
            GeometryReader { geometry -> AnyView in
                var frame = geometry.frame(in: .named("test"))               // << here !!
                frame.origin.y = UIScreen.main.bounds.size.height - kGuardian.slide
                return AnyView(Text("\(frame.origin.x), \(frame.origin.y)"))
    //                    .fixedSize(horizontal: false, vertical: true))
            }

        }
//        .offset(y:kGuardian.slide).animation(.easeInOut(duration: 1.0))
    }
    
    var bodyContet: some View {
        ZStack {
            outOfFocusArea
            sheetView
        }
    }
    
    public var body: some View {
        Group {
            if isShowing {
                bodyContet
//
                    
            }
        }
        .animation(.default)


    }
}


