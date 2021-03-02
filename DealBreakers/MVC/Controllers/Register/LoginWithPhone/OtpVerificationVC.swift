//
//  OtpVerificationVC.swift
//  DealBreakers
//
//  Created by Dharmani Apps 001 on 28/02/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreLocation

class OtpVerificationVC: UIViewController,UITextViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var sentOtpLabel: UILabel!
    @IBOutlet weak var otpTextFld: UITextField!
    @IBOutlet weak var signInTextView: UITextView!
    @IBOutlet weak var resendTextView: UITextView!
    var message = String()
    var message2 = String()
    var locationManager:CLLocationManager!
    var long = String()
    var lat = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTextFld.delegate = self
        signInTextView.isEditable = false
        assignAttributedtextToTextView()
        assignAttributedtextToTextViews()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        let number = UserDefaults.standard.value(forKey: "phoneNumber")
        
        sentOtpLabel.text = "OTP SENT AT YOUR REGISTERED MOBILE NUMBER(\(number! ))"
        
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }  
    }
    
    
    //    OTP SENT AT YOUR REGISTERED MOBILE NUMBER(9876543210)
    
    //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        lat = String(format: "%.6f", userLocation.coordinate.latitude)
        long = String(format: "%.6f", userLocation.coordinate.longitude)
//        lat = "\(userLocation.coordinate.latitude)"
//        long = "\(userLocation.coordinate.longitude)"
        UserDefaults.standard.set(lat, forKey: "lat")
        UserDefaults.standard.set(long, forKey: "long")
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    
    //MARK:    Attributed text Function
    
    func assignAttributedtextToTextViews() {
        self.resendTextView.attributedText = resendText()
        self.resendTextView.delegate = self
        self.resendTextView.linkTextAttributes = [NSMutableAttributedString.Key.font:UIFont(name: "ProximaNova-Regular", size: 16)!,NSMutableAttributedString.Key.foregroundColor:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
    }
    
    func assignAttributedtextToTextView() {
        self.signInTextView.attributedText = setLoginTextView()
        self.signInTextView.delegate = self
        self.signInTextView.textAlignment = .center
        self.signInTextView.linkTextAttributes = [NSMutableAttributedString.Key.font:UIFont(name: "ProximaNova-Regular", size: 16)!,NSMutableAttributedString.Key.foregroundColor:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
    }
    
    func setLoginTextView()->NSMutableAttributedString{
        let mainString = "Already have an account? Sign In"
        let attributedString = NSMutableAttributedString(string: mainString)
        let string1 = "Already have an account?"
        let rangeString = (mainString as NSString).range(of: string1)
        attributedString.addAttributes([NSMutableAttributedString.Key.font:UIFont(name: "ProximaNova-Regular", size: 15)!,NSMutableAttributedString.Key.foregroundColor:#colorLiteral(red: 0.533292532, green: 0.533357203, blue: 0.5332628489, alpha: 1)], range: rangeString)
        let string2 = "Sign In"
        let range2String = (mainString as NSString).range(of: string2)
        attributedString.addAttributes([NSMutableAttributedString.Key.font:UIFont(name: "ProximaNova-Regular", size: 15)!,NSMutableAttributedString.Key.foregroundColor:#colorLiteral(red: 0.1408141851, green: 0.1564493477, blue: 0.1997990608, alpha: 1)], range: range2String)
        let url = URL(string: "www.google.com")
        attributedString.addAttributes([NSMutableAttributedString.Key.link:url!], range: range2String)
        return attributedString
    }
    
    
    
    func resendText()->NSMutableAttributedString{
        let mainString = "If you not get OTP Resend again or update"
        let attributedString = NSMutableAttributedString(string: mainString)
        let string1 = "If you not get OTP"
        let string2 = "again or update"
        let rangeString = (mainString as NSString).range(of: string1)
        let rangeString2 = (mainString as NSString).range(of: string2)
        attributedString.addAttributes([NSMutableAttributedString.Key.font:UIFont(name: "ProximaNova-Regular", size: 15)!,NSMutableAttributedString.Key.foregroundColor:#colorLiteral(red: 0.533292532, green: 0.533357203, blue: 0.5332628489, alpha: 1)], range: rangeString)
        attributedString.addAttributes([NSMutableAttributedString.Key.font:UIFont(name: "ProximaNova-Regular", size: 15)!,NSMutableAttributedString.Key.foregroundColor:#colorLiteral(red: 0.533292532, green: 0.533357203, blue: 0.5332628489, alpha: 1)], range: rangeString2)
        let string3 = "Resend"
    //    let string4 = "Click Here"
        let rangeString3 = (mainString as NSString).range(of: string3)
  //      let rangeString4 = (mainString as NSString).range(of: string4)
        attributedString.addAttributes([NSMutableAttributedString.Key.font:UIFont(name: "ProximaNova-Regular", size: 15)!,NSMutableAttributedString.Key.foregroundColor:#colorLiteral(red: 0.1408141851, green: 0.1564493477, blue: 0.1997990608, alpha: 1)], range: rangeString3)
        
 //       attributedString.addAttributes([NSMutableAttributedString.Key.font:UIFont(name: "ProximaNova-Regular", size: 15)!,NSMutableAttributedString.Key.foregroundColor:#colorLiteral(red: 0.1408141851, green: 0.1564493477, blue: 0.1997990608, alpha: 1)], range: rangeString4)
        
        let url = URL(string: "Resend")
    //    let urls = URL(string : "Click Here")
        
        attributedString.addAttributes([NSMutableAttributedString.Key.link:url!], range: rangeString3)
//        attributedString.addAttributes([NSMutableAttributedString.Key.link:url!], range: rangeString4)
        return attributedString
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool
    {
        let currentCharacterCount = otpTextFld.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            alert(Constant.shared.appTitle, message: "Only 6 digit allowed", view: self)
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 6
    }
    
    
    //MARK:    Function for clickable Text View url
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        
        toRegenerateOtp()
//        self.navigationController?.popViewController(animated: true)
        // **Perform sign in action here**
        
        return false
    }
    
    func toRegenerateOtp()  {
        
        IJProgressView.shared.showProgressView()
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        let code = UserDefaults.standard.value(forKey: "countryCode") as? String ?? ""
        let strCode = "+\(code)"
        print(strCode)
        let phoneNumber = "\(UserDefaults.standard.value(forKey: "phoneNumber") ?? "")"
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            IJProgressView.shared.hideProgressView()
            
            if let error = error {
                IJProgressView.shared.hideProgressView()
                
                print(error.localizedDescription)
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
            }else{
                IJProgressView.shared.hideProgressView()
                
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
             //   print(verificationID)
            }
            IJProgressView.shared.hideProgressView()
        }
        IJProgressView.shared.hideProgressView()
        
    }
    
    
    //MARK:    Button Actions
    @IBAction func varifyButtonTap(_ sender: Any) {
        
        let checkComesDataFrom = UserDefaults.standard.value(forKey: "updateNumner") as? Bool
        
        if checkComesDataFrom == true{
            
            signInTextView.isHidden = true
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: otpTextFld.text!)
            
            Auth.auth().signIn(with: credential) { (success, error) in
                if error == nil{
                    print(success ?? "")
                  //  print(Auth.auth().currentUser?.uid)
                    self.updateNumberApi()
                }else{
                    alert(Constant.shared.appTitle, message: error?.localizedDescription ?? "", view: self)
                 //   print(error?.localizedDescription)
                }
            }
            
        }else{
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: otpTextFld.text!)
            
            Auth.auth().signIn(with: credential) { (success, error) in
                if error == nil{
                    print(success ?? "")
               //     print(Auth.auth().currentUser?.uid)
                    self.checkPhoneNumber()
                }else{
               //     print(error?.localizedDescription)
                    alert(Constant.shared.appTitle, message: error?.localizedDescription ?? "", view: self)
                }
            }
        }
    }
    
    
    
    func updateNumberApi()  {
        
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        let code = UserDefaults.standard.value(forKey: "countryCode") as? String ?? ""
        let strCode = "+\(code)"
        print(strCode)
        let phoneNumber = "\(UserDefaults.standard.value(forKey: "phoneNumber"))"
        let numberWithCountryCode = strCode + phoneNumber
        //        UserDefaults.standard.set(numberWithCountryCode, forKey: "phoneNumber")
        let userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        IJProgressView.shared.showProgressView()
        let signUpUrl = Constant.shared.baseUrl + Constant.shared.updateNumber
        
        let parms : [String:Any] = ["user_id": userId,"phone": numberWithCountryCode]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            let result = response as AnyObject
            let status = response["status"] as? Int
            self.message = response["message"] as? String ?? ""
            if status == 1{
                alert(Constant.shared.appTitle, message: self.message, view: self)
                let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
                self.navigationController?.pushViewController(newViewController, animated: true)
                
            }else{
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: self.message, view: self)
            }
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            print(error)
            
        }
        
    }
    
    @IBAction func backButtonTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func checkPhoneNumber() {
        IJProgressView.shared.showProgressView()
        let signUpWithPhoneUrl = Constant.shared.baseUrl + Constant.shared.checkNumberExist
        let id = UserDefaults.standard.value(forKey: "phoneNumber")
        let idStr = "\(id ?? "")"
        var deviceID = UserDefaults.standard.value(forKey: "device_token") as? String
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let parms : [String:Any] = ["phone": idStr,"device_token": deviceID ?? "","device_type":"1"]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpWithPhoneUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            self.message = response["message"] as? String ?? ""
            if let status = response["status"] as? Int{
                if status == 1{
                    UserDefaults.standard.set(true, forKey: "tokenFString")
                    
                    if let dataDict = response as? NSDictionary{
                        print(dataDict)
                        let userId = dataDict["user_id"] as? String
                        print(userId ?? 0)
                        UserDefaults.standard.set(userId, forKey: "userId")
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController?.pushViewController(newViewController, animated: true)
                    }
                }else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddUserdetailsVC") as! AddUserdetailsVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    vc.userFbDetails = parms
                }
            }
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            alert(Constant.shared.appTitle, message: "Data not found", view: self)
            print(error)
        }
    }    
}
