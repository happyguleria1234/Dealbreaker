//
//  SignUpVC.swift
//  DealBreakers
//
//  Created by Dharmani Apps 001 on 28/02/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import CountryList

class SignUpVC: UIViewController,UITextViewDelegate,CountryListDelegate {
    
    @IBOutlet weak var countrycodeLabel: UILabel!
    @IBOutlet weak var phoneNumberTextFld: UITextField!
    @IBOutlet weak var signUpTextView: UITextView!
    var countryList = CountryList()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignAttributedtextToTextView()
        countryList.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:    Attributed text function
    
    
    func assignAttributedtextToTextView() {
        signUpTextView.isEditable = false
        self.signUpTextView.attributedText = setLoginTextView()
        self.signUpTextView.delegate = self
        self.signUpTextView.textAlignment = .center
        self.signUpTextView.linkTextAttributes = [NSMutableAttributedString.Key.font:UIFont(name: "ProximaNova-Regular", size: 17)!,NSMutableAttributedString.Key.foregroundColor:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
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
    
    //MARK:   Function for clickable Text View url
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        self.navigationController?.popViewController(animated: true)
        // **Perform sign in action here**
        
        return false
    }
    
    
    //MARK:   Country List Function
    
    func selectedCountry(country: Country) {
        self.countrycodeLabel.text = "(+\(country.phoneExtension))\(country.countryCode)"
        print(countrycodeLabel!)
        UserDefaults.standard.set(country.phoneExtension, forKey: "countryCode")
        
    }
    
    
//    \(country.flag!)
    
    //MARK:    Button Actions
    
    
    @IBAction func openCountryCodeListButtonTap(_ sender: Any) {
        let vc = UINavigationController(rootViewController: countryList)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTap(_ sender: Any) {

        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func nextButtonTap(_ sender: Any) {
        
//        if countrycodeLabel.text?.isEmpty ?? true {
//            
//            countrycodeLabel.text = "+91"
//            
//        }
        
        IJProgressView.shared.showProgressView()
        let code = UserDefaults.standard.value(forKey: "countryCode") as? String ?? "1"
        let strCode = "+\(code)"
        print(strCode)
        let numberWithCountryCode =  strCode + (phoneNumberTextFld.text ?? "")
        UserDefaults.standard.set(numberWithCountryCode, forKey: "phoneNumber")
        print(numberWithCountryCode)
        PhoneAuthProvider.provider().verifyPhoneNumber(numberWithCountryCode, uiDelegate: nil) { (verificationID, error) in
            IJProgressView.shared.hideProgressView()

            if let error = error {
                IJProgressView.shared.hideProgressView()

                print(error.localizedDescription)
                if error.localizedDescription == "Invalid format."{
                  alert(Constant.shared.appTitle, message: "please enter valid phone number.", view: self)
                }else{
                   alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                }
                
            }else{
                IJProgressView.shared.hideProgressView()

                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                print(verificationID)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtpVerificationVC") as! OtpVerificationVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            IJProgressView.shared.hideProgressView()

        }
        IJProgressView.shared.hideProgressView()

    }
}

extension UIViewController {
    
    func ValidatesData(strMessage: String)
    {
        let alert = UIAlertController(title: Constant.shared.appTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
