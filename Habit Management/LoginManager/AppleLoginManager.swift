//
//  AppleLoginManager.swift
//  Habit Management
//
//  Created by 한수진 on 2022/08/10.
//

import Foundation
import AuthenticationServices

class AppleLoginManager: NSObject {
    
//    static let shared = AppleLoginManager()
    
    var currentNonce: String?
    let window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // Handle error.
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      switch authorization.credential {
      case let appleIDCredential as ASAuthorizationAppleIDCredential:
        let userIdentifier = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        let email = appleIDCredential.email
        
      case let passwordCredential as ASPasswordCredential:
        let username = passwordCredential.user
        let password = passwordCredential.password
          
          print("apple username", username)
      
      default:
        break
      }
    }

}

extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    window!
  }
}

