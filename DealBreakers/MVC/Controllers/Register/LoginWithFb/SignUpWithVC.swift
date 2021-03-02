//
//  SignUpWithVC.swift
//  DealBreakers
//
//  Created by Dharmani Apps 001 on 28/02/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import Alamofire
import AuthenticationServices

class SignUpWithVC: UIViewController {
    
    var message = String()
    var my_id:String! = ""
    var first_name:String! = ""
    var last_name:String! = ""
    var email:String! = ""
    var img_url:String! = ""
    var name = ""
    
    
    
    //    var birthday:String! = "17/01/1992"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:    Buttons Actions
    
    @IBAction func phoneLoginButtonTap(_ sender: Any) {
        UserDefaults.standard.set("phone", forKey: "LoginFrom")
//        UserDefaults.standard.set(true, forKey: "phoneLogin")
//        UserDefaults.standard.set(false, forKey: "fbLogin")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func appleLogInBtnAction(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            UserDefaults.standard.set("apple", forKey: "LoginFrom")
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        } else {
            DispatchQueue.main.async {
                alert(Constant.shared.appTitle, message: "Apple login support in iOS 13 and above", view: self)
            }
        }
    }
    
    @IBAction func fbLoginButtonTap(_ sender: Any) {
        UserDefaults.standard.set("fb", forKey: "LoginFrom")
//        UserDefaults.standard.set(true, forKey: "fbLogin")
//        UserDefaults.standard.set(false, forKey: "phoneLogin")
        if Reachability.isConnectedToNetwork(){
            fbLogin()
        }else{
            alert(Constant.shared.appTitle, message: "No internet connection", view: self)
        }
    }
    func fbLogin()  {
        
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if error == nil{
                let fbloginresult : LoginManagerLoginResult = result!
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }else{
                print("Failed to login: \(error?.localizedDescription ?? "")")
                return
            }
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
//            IJProgressView.shared.showProgressView()
//            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
//
//            // Perform login by calling Firebase APIs
//            IJProgressView.shared.hideProgressView()
//            Auth.auth().signIn(with: credential, completion: { (user, error) in
//                if let error = error {
//                    print("Login error: \(error.localizedDescription)")
//                    print(Auth.auth().currentUser?.uid)
//                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(okayAction)
//                    self.present(alertController, animated: true, completion: nil)
//
//                    return
//                }else{
//
//                    print(Auth.auth().currentUser?.uid)
//                    UserDefaults.standard.set((Auth.auth().currentUser?.email), forKey: "email")
//                    print(Auth.auth().currentUser?.email)
//                    print(Auth.auth().currentUser?.displayName)
//
//                    UserDefaults.standard.set((Auth.auth().currentUser?.displayName), forKey: "name")
//                    UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "FbID")
//                    let phoneNumber = "9876543210"
//                    UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
//                    self.checkFbAccountExist()
//                }
//
//            })
        }
    }
    func getFBUserData(){
            self.view.isUserInteractionEnabled = false
            IJProgressView.shared.showProgressView()
            if((AccessToken.current) != nil){
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let dict = result as! [String : AnyObject]
                        print(dict)
                        if let dict = result as? [String : AnyObject]{
                            if(dict["email"] as? String == nil || dict["id"] as? String == nil || dict["email"] as? String == "" || dict["id"] as? String == "" ){
                                
                                self.view.isUserInteractionEnabled = true
                                IJProgressView.shared.hideProgressView()
                                alert(Constant.shared.appTitle, message: "You cannot login with this facebook account because your facebook is not linked with any email", view: self)
                                
                            }else{
                                IJProgressView.shared.hideProgressView()
                                self.email = dict["email"] as? String
                                self.first_name = dict["first_name"] as? String
                                self.last_name = dict["last_name"] as? String
                                self.name = dict["name"] as? String ?? ""
                                let id = dict["id"] as? String
                                UserDefaults.standard.set(id, forKey: "FbID")
                              
                                self.checkFbAccountExist()
                            }
                        }
                        
                    }else{
                        self.view.isUserInteractionEnabled = true
                        IJProgressView.shared.hideProgressView()
                        
                        
                    }
                })
            }
            
        }
    func checkFbAccountExist() {
        
        IJProgressView.shared.showProgressView()
        let signUpWithPhoneUrl = Constant.shared.baseUrl + Constant.shared.checkFbAccountExist
        let id = UserDefaults.standard.value(forKey: "FbID") as? String
//        let idStr = "\(id ?? "")"
        var deviceID = UserDefaults.standard.value(forKey: "device_token") as? String
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let parms : [String:Any] = ["fb_id": id ?? "","device_token": deviceID ?? "","device_type":"1"]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpWithPhoneUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            self.message = response["message"] as? String ?? ""
            if let status = response["status"] as? Int{
                if status == 1{
                    UserDefaults.standard.set(true, forKey: "tokenFString")
                    
                    if let dataDict = response as? [String:Any]{
                        print(dataDict)
                        let userId = dataDict["user_id"] as? String
                        print(userId ?? 0)
                        UserDefaults.standard.set(userId, forKey: "userId")
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController?.pushViewController(newViewController, animated: true)
                    }
                }else if status == 0{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddUserdetailsVC") as! AddUserdetailsVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    vc.emailStr = self.email
                    vc.firstNameStr = self.name
                    vc.userFbDetails = parms
                }else{
                    IJProgressView.shared.hideProgressView()
                    alert(Constant.shared.appTitle, message: self.message, view: self)
                }
            }
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            alert(Constant.shared.appTitle, message: "Data not found", view: self)
            print(error)
        }
    }
    
    
    //    func getData() {
    //        IJProgressView.shared.showProgressView()
    //        let signUpWithFBUrl = Constant.shared.baseUrl + Constant.shared.fbLogin
    //        let id = UserDefaults.standard.value(forKey: "userId")
    //        let idStr = "\(id ?? "")"
    //        let parms : [String:Any] = ["fb_id": "\(id ?? "")","device_toke": "462F58AF3DDD65D586B2EFE72DD8055BB5CC5578BD247775D174709820E38E68","device_type":"1"]
    //        print(parms)
    //        AFWrapperClass.requestUrlEncodedPOSTURL(signUpWithFBUrl, params: parms, success: { (response) in
    //            IJProgressView.shared.hideProgressView()
    //            self.message = response["message"] as? String ?? ""
    //            if let status = response["status"] as? Int{
    //                if status == 1{
    //                    UserDefaults.standard.set(true, forKey: "comesFromFb")
    //                    UserDefaults.standard.set(true, forKey: "tokenFString")
    //                    if let dataDict = response as? NSDictionary{
    //                        print(dataDict)
    //                        //                        let id = dataDict["user_id"] as? Any
    //                        //                        UserDefaults.standard.set(id, forKey: "userId")
    //                        IJProgressView.shared.hideProgressView()
    //                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddUserdetailsVC") as! AddUserdetailsVC
    //                        self.navigationController?.pushViewController(vc, animated: true)
    //                        vc.userFbDetails = parms
    //                        vc.firstNameTextFld.text = "\(UserDefaults.standard.value(forKey: "name") ?? "")"
    //                        vc.emailTextFld.text = "\(UserDefaults.standard.value(forKey: "email") ?? "")"
    //
    //                    }
    //                }else{
    //                    IJProgressView.shared.hideProgressView()
    //                    alert(Constant.shared.appTitle, message: self.message, view: self)
    //                }
    //            }
    //        }) { (error) in
    //            IJProgressView.shared.hideProgressView()
    //            alert(Constant.shared.appTitle, message: "Data not found", view: self)
    //            print(error)
    //        }
    //    }
    func checkAppleAccountExist(email:String,firstName:String,lastName:String,appleID:String) {
            
            IJProgressView.shared.showProgressView()
            let signUpWithPhoneUrl = Constant.shared.baseUrl + Constant.shared.CheckAppleExists
            var deviceID = UserDefaults.standard.value(forKey: "device_token") as? String
            print(deviceID ?? "")
            if deviceID == nil  {
                deviceID = "777"
            }
        let parms : [String:Any] = ["apple_id": appleID ,"device_token": deviceID ?? "","device_type":"1"]
            print(parms)
            AFWrapperClass.requestPOSTURL(signUpWithPhoneUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.message = response["message"] as? String ?? ""
                if let status = response["status"] as? Int{
                    if status == 1{
                        UserDefaults.standard.set(true, forKey: "tokenFString")
                        
                        if let dataDict = response as? [String:Any]{
                            print(dataDict)
                            let userId = dataDict["user_id"] as? String
                            print(userId ?? 0)
                            UserDefaults.standard.set(userId, forKey: "userId")
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                            self.navigationController?.pushViewController(newViewController, animated: true)
                        }
                    }else if status == 0{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddUserdetailsVC") as! AddUserdetailsVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        vc.emailStr = email
                        vc.firstNameStr = firstName + " " + lastName
                        vc.userFbDetails = parms
                    }else{
                        IJProgressView.shared.hideProgressView()
                        alert(Constant.shared.appTitle, message: self.message, view: self)
                    }
                }
            }) { (error) in
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: "Data not found", view: self)
                print(error)
            }
        }
    
}
extension SignUpWithVC : ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let userFirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            print(userFirstName,userLastName,fullName)
            if let email = appleIDCredential.email, let _ = appleIDCredential.fullName  {
                UserDefaults.standard.setValue(userIdentifier, forKey: "appleId")
                UserDefaults.standard.setValue(userFirstName, forKey: "appleFirstName")
                UserDefaults.standard.setValue(userLastName, forKey: "appleLastName")
                UserDefaults.standard.setValue(email, forKey: "appleEmail")
                self.checkAppleAccountExist(email: email, firstName: userFirstName ?? "",lastName: userLastName ?? "", appleID: userIdentifier)
            }else {
                let userId = UserDefaults.standard.value(forKey: "appleId") as? String
                var first_name = ""
                var Last_name = ""
                var email = ""
                if userIdentifier == userId {
                    first_name = UserDefaults.standard.value(forKey: "appleFirstName") as? String ?? ""
                    Last_name = UserDefaults.standard.value(forKey: "appleLastName")  as? String ?? ""
                    email = UserDefaults.standard.value(forKey: "appleEmail") as? String ?? ""
                }
            self.checkAppleAccountExist(email: email, firstName: first_name,lastName: Last_name, appleID: userIdentifier)
            }
        }
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        DispatchQueue.main.async {
            alert(Constant.shared.appTitle, message:error.localizedDescription, view: self)
             IJProgressView.shared.hideProgressView()
        }
    }
        
}
