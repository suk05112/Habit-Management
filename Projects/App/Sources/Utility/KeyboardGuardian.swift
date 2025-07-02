//
//  KeyboardGuardian.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/23.
//

import Foundation
import SwiftUI
import Combine

final class KeyboardGuardian: ObservableObject {
    public var rects: Array<CGRect>
//    public var rects: CGRect

    public var keyboardRect: CGRect = CGRect()

    // keyboardWillShow notification may be posted repeatedly,
    // this flag makes sure we only act once per keyboard appearance
    public var keyboardIsHidden = true

    @Published var slide: CGFloat = 600

    var showField: Int = 0 {
        didSet {
            print("didset")
            updateSlide()
        }
    }

    init(textFieldCount: Int) {
        self.rects = Array<CGRect>(repeating: CGRect(), count: textFieldCount)
    }

    func addObserver() {
        print("add observer")
NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
}

func removeObserver() {
 NotificationCenter.default.removeObserver(self)
}

    deinit {
        NotificationCenter.default.removeObserver(self)
    }



    @objc func keyBoardWillShow(notification: Notification) {
        if keyboardIsHidden {
            keyboardIsHidden = false
            
            if let rect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
                keyboardRect = rect
                updateSlide()
            }
        }
    }

    @objc func keyBoardDidHide(notification: Notification) {
        keyboardIsHidden = true
        updateSlide()
    }

    func updateSlide() {
        
        if keyboardIsHidden {
            slide = 700
        } else {
            
//            let tfRect = self.rects[self.showField]
//            let diff = keyboardRect.minY
            print("keybord height: ", keyboardRect.height, "maxY", keyboardRect.maxY)
            let tfRect = self.rects[self.showField]
            let diff = keyboardRect.minY - tfRect.maxY
            

            if diff > 0 {
//                slide += diff
            } else {
                slide += min(diff, 0)
            }
//            slide = UIScreen.main.bounds.size.height - keyboardRect.height
//            slide = keyboardRect.maxY

        }
        slide = 800
        print("slide = ", slide)
    }
}


struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                DispatchQueue.main.async {
                    self.rect = geometry.frame(in: .global)
                }

                return AnyView(Color.clear)
            }
        }
    }
}
