//
//  KakaoLoginManager.swift
//  Habit Management
//
//  Created by 한수진 on 2022/08/09.
//

import Foundation
import UIKit

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

public class KakaoLoginManager: NSObject {
    
    
    static let shared = KakaoLoginManager()
    
    public var code: String?
    
    override init() {
        super.init()
    }
    
    func checkToken() {
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        self.login()

                        //로그인 필요
                    }
                    else {
                        //기타 에러
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    print("토큰 유효함. 로그인 불필요")
                    self.getProfile()
                }
            }
        }
        else {
            //로그인 필요
            print("토큰 값 없음. 로그인 필요")
            login()
        }
    }

    private func login() {
        print("bundle name", Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY"))
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            //카카오톡이 설치되어있다면 카카오톡을 통한 로그인 진행
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                print(oauthToken?.accessToken)
                print(error)
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    self.getProfile()
                    //do something
                    _ = oauthToken
                }
            }
        }else{
            //카카오톡이 설치되어있지 않다면 사파리를 통한 로그인 진행
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                print(oauthToken?.accessToken)
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    self.getProfile()
                    //do something
                    _ = oauthToken
                }
                print(error)
            }
        }
        

    }
    
    public func logout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
        
    }
    
    private func getProfile() {
        UserApi.shared.me(){ (user, error) in
            
            UserApi.shared.me() {(user, error) in
                if let error = error {
                    print("정보받아오기 실패")
                    print(error)
                }
                else {
                    print("me() success.")
                    print("정보받아오기 성공")
                    print(user?.kakaoAccount?.profile?.nickname)
                    print(user?.kakaoAccount?.name)
                    print(user?.kakaoAccount?.email)

                    _ = user
                }
            }

        }
    }
}

/*

case "snsLogin":
    if let message = message.body as? Dictionary<String, Any> {
        if message.count != 0 {
            let snsType = message["snsType"] as? String
            let url = message["url"] as? String
            switch snsType {
            case "naver":
                NaverLoginManager.shared.getEmail { (id, name, email, nick, photo) in
                    let abUrl = "https://www.wowplace.kr/page/social_login.php?provider=\(String(describing: snsType!))&id=\(id)&nick=\(nick)&email=\(email)&photo=\(photo)&name=\(name)&url=\(String(describing: url!))"
                    let encoded = abUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    
                    self.getCurrentWebview().load(URLRequest(url: URL(string: encoded!)!))
                    
                }
                break
            case "kakao" :
                KakaoLoginManager.shared.getKakaoProfile { (me) in
                    print("me!!")
                    print(me as Any)
                    let id: String = (me?.id)!
                    let nick: String = (me?.nickname)!
                    let email: String = (me?.account?.email)!
                    let profile: String = (me?.profileImageURL!.absoluteString)!
                    let abUrl = "https://www.wowplace.kr/page/social_login.php?provider=\(snsType!)&id=\(id)&nick=\(nick)&email=\(email)&photo=\(profile)&name=\(nick)&url=\(url!)"

                    let encoded = abUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    self.getCurrentWebview().load(URLRequest(url: URL(string: encoded!)!))
                }
                break
                
            case "apple" :
                if #available(iOS 13.0, *) {
                            
                    AppleLoginManager.shared.signIn(controller: self) { (profile) in
                        
                        let name: String = (profile.name)!
                        let email: String = (profile.email)!
                        let id: String = (profile.userId)!

                        let abUrl = "https://www.wowplace.kr/page/social_login.php?provider=\(snsType!)&id=\(id)&nick=&email=\(email)&photo=&name=\(name)&url=\(url!)"
                        let encoded = abUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        self.getCurrentWebview().load(URLRequest(url: URL(string: encoded!)!))
                        
                    } onFailure: { (error) in
                        print("AppleLogin error : \(String(describing: error.localizedDescription))")
                    }

                }
                 
                break
                 
            default :
                break
            }
        }
    }
*/
