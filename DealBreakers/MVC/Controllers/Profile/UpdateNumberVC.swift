//
//  UpdateNumberVC.swift
//  DealBreakers
//
//  Created by Vivek Dharmani on 3/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import CountryList
import FirebaseAuth
import Firebase

class UpdateNumberVC: UIViewController,CountryListDelegate {
    
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var numberTF: UITextField!
    var countryList = CountryList()
    var messgae = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        countryList.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func selectedCountry(country: Country) {
        self.countryCodeLabel.text = "(+\(country.phoneExtension))\(country.countryCode)"
        print(countryCodeLabel!)
        UserDefaults.standard.set(country.phoneExtension, forKey: "countryCode")
        
    }
    
    @IBAction func nextButtonTap(_ sender: Any) {
        
        IJProgressView.shared.showProgressView()
        let code = UserDefaults.standard.value(forKey: "countryCode") as? String ?? "1"
        let strCode = "+\(code)"
        print(strCode)
        let numberWithCountryCode =  strCode + (numberTF.text ?? "")
        UserDefaults.standard.set(numberWithCountryCode, forKey: "phoneNumber")
        print(numberWithCountryCode)
        PhoneAuthProvider.provider().verifyPhoneNumber(numberWithCountryCode, uiDelegate: nil) { (verificationID, error) in
            IJProgressView.shared.hideProgressView()
            
            if let error = error {
                IJProgressView.shared.hideProgressView()
                
                print(error.localizedDescription)
                alert(Constant.shared.appTitle, message: "Your mobile number is not valid", view: self)
            }else{
                IJProgressView.shared.hideProgressView()
                UserDefaults.standard.set(verificationID, forKey: "verifictionID")
                print(verificationID)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPFromUpdateNumberVC") as! OTPFromUpdateNumberVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            IJProgressView.shared.hideProgressView()
            
        }
        IJProgressView.shared.hideProgressView()
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func openCounrtyButtonTap(_ sender: Any) {
        let vc = UINavigationController(rootViewController: countryList)
        self.present(vc, animated: true, completion: nil)
    }
    
}
