//
//  LoginView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/08/09.
//

import Foundation
import SwiftUI

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

import AuthenticationServices
import FirebaseAuth


struct LoginView: View {
    let kakoManager = KakaoLoginManager.shared
    @State var myemail = ""
    @Environment(\.window) var window: UIWindow?
    @State var appleSignInDelegates: SignInWithAppleDelegates! = nil

    var body: some View {
        VStack{
            Text("\(myemail)")
            Button(action : {
                kakoManager.checkToken()
            })
            {
                Text("카카오 로그인")
            }
            Button(action : {
                kakoManager.logout()
            })
            {
                Text("카카오 로그아웃")
            }
            
            SignInWithApple()
              .frame(width: 280, height: 60)
              .onTapGesture {
                      appleLogin()
                  getprofile()
                    }
//              .onTapGesture(perform: showAppleLogin)
            Button(action : {
                appleSignInDelegates.logout()
                myemail = ""
                getprofile()
            })
            {
                Text("애플 로그아웃")
            }
        }
//        .onAppear {
//          self.performExistingAccountSetupFlows()
//        }
        
        
    }
    
    func getprofile(){
        let user = Auth.auth().currentUser
//        var myemail = ""
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          let uid = user.uid
          let email = user.email
          let photoURL = user.photoURL
          var multiFactorString = "MultiFactor: "
          for info in user.multiFactor.enrolledFactors {
            multiFactorString += info.displayName ?? "[DispayName]"
            multiFactorString += " "
          }
          // ...
            myemail = email!

        }
        print("파베 이메일", myemail)

//        return myemail

    }
    
    func appleLogin() {
//        appleSignInDelegates = SignInWithAppleDelegates(window: window)
        appleSignInDelegates = SignInWithAppleDelegates(window: window) { success in
          if success {
            // update UI
          } else {
            // show the user an error
          }
        }
        appleSignInDelegates?.startSignInWithAppleFlow()
    }
    
    private func showAppleLogin() {
      let request = ASAuthorizationAppleIDProvider().createRequest()
      request.requestedScopes = [.fullName, .email]
      performSignIn(using: [request])
    }

    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    private func performExistingAccountSetupFlows() {
      #if !targetEnvironment(simulator)
      // Note that this won't do anything in the simulator.  You need to
      // be on a real device or you'll just get a failure from the call.
      let requests = [
        ASAuthorizationAppleIDProvider().createRequest(),
        ASAuthorizationPasswordProvider().createRequest()
      ]

      performSignIn(using: requests)
      #endif
    }

    private func performSignIn(using requests: [ASAuthorizationRequest]) {
//        appleSignInDelegates = SignInWithAppleDelegates(window: window)

      appleSignInDelegates = SignInWithAppleDelegates(window: window) { success in
        if success {
          // update UI
        } else {
          // show the user an error
        }
      }

      let controller = ASAuthorizationController(authorizationRequests: requests)
      controller.delegate = appleSignInDelegates
      controller.presentationContextProvider = appleSignInDelegates

      controller.performRequests()
    }
    
}


final class SignInWithApple: UIViewRepresentable {
  func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
    return ASAuthorizationAppleIDButton()
  }
  
  func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
  }
}

