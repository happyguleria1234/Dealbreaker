//
//  SettingVC.swift
//  DealBreakers
//
//  Created by Dharmani Apps 001 on 04/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import RangeSeekSlider
import WebKit
import FirebaseAuth

class SettingVC: UIViewController,RangeSeekSliderDelegate {
    
    
    @IBOutlet weak var shemaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maxDistanceLabel: UILabel!
    @IBOutlet weak var minDIstanceLabel: UILabel!
    @IBOutlet weak var maxAgeLabel: UILabel!
    @IBOutlet weak var minAgelabel: UILabel!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var locationSlider: RangeSeekSlider!
    @IBOutlet weak var ageSlider: RangeSeekSlider!
    
    
    var minAge = String()
    var maxAge = String()
    var minDistance = String()
    var maxDistance = String()
    var gender = String()
    
    var message = String()
    var lat = String()
    var long = String()
    var imgArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ageSlider.delegate = self
        
       
        ageSlider.delegate = self

        locationSlider.delegate = self

        emailTF.isUserInteractionEnabled = false
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         self.getData()
    }
    
    //MARK:    Button Actions
    
    
    
    @IBAction func editQuestionButtonTap(_ sender: Any) {
        
       // UserDefaults.standard.set(true, forKey: "comesFromSettingVc")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
        newViewController.fromSettings = true
        self.navigationController?.pushViewController(newViewController, animated: true)
 
    }
    
    
    @IBAction func updateButtonTap(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateNumberVC") as! UpdateNumberVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func savetnAction(_ sender: UIButton) {
        IJProgressView.shared.showProgressView()
        let signUpWithFBUrl = Constant.shared.baseUrl + Constant.shared.Filter
        lat = UserDefaults.standard.value(forKey: "lat") as? String ?? ""
        long = UserDefaults.standard.value(forKey: "long") as? String ?? ""
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        let parms : [String:Any] = ["user_id": id, "age1" : minAge, "age2" : maxAge, "distance1" : minDistance, "distance2" : maxDistance, "gender" : gender, "present_latitude" : lat, "present_longitude" : long]
        
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpWithFBUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            print(response)
            self.message = response["message"] as? String ?? ""
            if let status = response["status"] as? Int{
                if status == 1{
                   // showAlertMessage(title: Constant.shared.appTitle, message: self.message, okButton: "OK", controller: self) {
                       self.navigationController?.popViewController(animated: true)
                  //  }
                    
                }else{
//                    IJProgressView.shared.hideProgressView()
//                    self.navigationController?.popViewController(animated: true)
//                    alert(Constant.shared.appTitle, message: self.message, view: self)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
            print(error)
        }
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        self.logOut()
    }
    
    @IBAction func backButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func termsOfServicesButtonTap(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Terms_ConditionsVC") as! Terms_ConditionsVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func contactUsButtonTap(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func helpSupportButtonTap(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Help_SupprtVC") as! Help_SupprtVC
              self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func privecyButtonTap(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Privecy_PolicyVC") as! Privecy_PolicyVC
                     self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func femaleButtonAction(_ sender: Any) {
        self.gender = "Female"
        femaleButton.isSelected = true
        maleButton.isSelected = false
        shemaleButton.isSelected = false
        femaleButton.backgroundColor = #colorLiteral(red: 0.9824941754, green: 0.3275985718, blue: 0.4800108075, alpha: 1)
        maleButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        shemaleButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        femaleButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .disabled)
        maleButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .disabled)
        shemaleButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .disabled)
        
    }
    
    
    @IBAction func maleButtonAction(_ sender: Any) {
        maleButton.isSelected = true
        self.gender = "Male"
        femaleButton.isSelected = false
        shemaleButton.isSelected = false
        maleButton.backgroundColor = #colorLiteral(red: 0.9824941754, green: 0.3275985718, blue: 0.4800108075, alpha: 1)
        femaleButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        shemaleButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        maleButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .disabled)
        femaleButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .disabled)
        shemaleButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .disabled)
    }
    
    @IBAction func shemaleButtonAction(_ sender: Any) {
        self.gender = "SheMale"
        shemaleButton.isSelected = true
        femaleButton.isSelected = false
        maleButton.isSelected = false
        shemaleButton.backgroundColor = #colorLiteral(red: 0.9824941754, green: 0.3275985718, blue: 0.4800108075, alpha: 1)
        maleButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        femaleButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        shemaleButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .disabled)
        maleButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .disabled)
        femaleButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .disabled)
    }
    
    
    func getData() {
        
        IJProgressView.shared.showProgressView()
        let signUpUrl = Constant.shared.baseUrl + Constant.shared.userDetaila
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        lat = UserDefaults.standard.value(forKey: "lat") as? String ?? ""
        long = UserDefaults.standard.value(forKey: "long") as? String ?? ""
        
        let parms : [String:Any] = ["user_id": id,"present_latitude": lat,"present_longitude": long]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            let result = response as AnyObject
            print(result)
            if let dataDict = result["data"] as? [String:Any]{
                let phoneNumber = dataDict["phone"] as? Any
                print(phoneNumber as? String ?? "")
                self.phoneNumberTF.text! = dataDict["phone"] as? String ?? ""
                self.emailTF.text! = dataDict["email"] as? String ?? ""
                if let filterData = dataDict["filter_data"] as? [String:Any]{
                    print(filterData)
                    self.minAge = filterData["age1"] as? String ?? ""
                    self.maxAge = filterData["age2"] as? String ?? ""
                    self.minDistance = filterData["distance1"] as? String ?? ""
                    self.maxDistance = filterData["distance2"] as? String ?? ""
                    self.minAgelabel.text = "Min: \(self.minAge) Years"
                    self.maxAgeLabel.text = "Max: \(self.maxAge) Years"
                    self.ageSlider.selectedMinValue = CGFloat(NumberFormatter().number(from: self.minAge)?.floatValue ?? 18.0)
                    self.ageSlider.selectedMaxValue = CGFloat(NumberFormatter().number(from: self.maxAge)?.floatValue ?? 60.0)
                    self.ageSlider.setNeedsLayout()
                    self.locationSlider.selectedMinValue = CGFloat(NumberFormatter().number(from: self.minDistance)?.floatValue ?? 0.0)
                    self.locationSlider.selectedMaxValue = CGFloat(NumberFormatter().number(from:self.maxDistance)?.floatValue ?? 100.0)
                    self.minDIstanceLabel.text = "Min: \(self.minDistance) miles"
                    self.maxDistanceLabel.text = "Max: \(self.maxDistance) miles"
                    self.locationSlider.setNeedsLayout()
                    self.gender = filterData["filter_gender"] as? String ?? ""
                    if self.gender == "Male"{
                        self.maleButton.isSelected = true
                        self.maleButton.backgroundColor = #colorLiteral(red: 0.9824941754, green: 0.3275985718, blue: 0.4800108075, alpha: 1)
                        self.maleButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .disabled)
                    }else if self.gender == "Female"{
                        self.femaleButton.isSelected = true
                        self.femaleButton.backgroundColor = #colorLiteral(red: 0.9824941754, green: 0.3275985718, blue: 0.4800108075, alpha: 1)
                        self.femaleButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .disabled)
                    }else if self.gender == "SheMale"{
                        self.shemaleButton.isSelected = true
                        self.shemaleButton.backgroundColor = #colorLiteral(red: 0.9824941754, green: 0.3275985718, blue: 0.4800108075, alpha: 1)
                        self.shemaleButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .disabled)
                    }
                }
               

               
            }
            
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            print(error)
            
        }
    }
    
    func logOut() {
        
        
        let dialogMessage = UIAlertController(title: Constant.shared.appTitle, message: "Are you sure want to logout?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button click...")
            IJProgressView.shared.showProgressView()
                   let signUpUrl = Constant.shared.baseUrl + Constant.shared.Logout
                   let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
                   var deviceID = UserDefaults.standard.value(forKey: "device_token") as? String
                   print(deviceID ?? "")
                   if deviceID == nil  {
                       deviceID = "777"
                   }
                   let parms : [String:Any] = ["user_id": id,"device_token": deviceID ?? "","device_type":"1"]
                   print(parms)
                   AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
                   IJProgressView.shared.hideProgressView()
                    let message = response["message"] as? String ?? ""
                    if let status = response["status"] as? Int{
                        if status == 1{
                            UserDefaults.standard.removeObject(forKey: "tokenFString")
                            UserDefaults.standard.removeObject(forKey:"userId")
                            UserDefaults.standard.set(false, forKey: "comesFromSettingVc")
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.logout()
                        }else{
                          alert(Constant.shared.appTitle, message: message, view: self)
                        }
                    }
                   }) { (error) in
                       IJProgressView.shared.hideProgressView()
                       print(error)
                       
                   }
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button click...")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    
    func deleteAcc() {
        
        
        let dialogMessage = UIAlertController(title: Constant.shared.appTitle, message: "Are you sure want to delete your account permanently?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button click...")
            self.deleteAccount()
            
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button click...")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        self.deleteAcc()
    }
    
    func deleteAccount()  {
        IJProgressView.shared.showProgressView()
        let signUpWithFBUrl = Constant.shared.baseUrl + Constant.shared.deleteAccount
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        let parms : [String:Any] = ["user_id": id]

        print(parms)
        AFWrapperClass.requestPOSTURL(signUpWithFBUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            self.message = response["message"] as? String ?? ""
            if let status = response["status"] as? Int{
                if status == 1{
                    showAlertMessage(title: Constant.shared.appTitle, message: self.message, okButton: "OK", controller: self) {
                        UserDefaults.standard.removeObject(forKey: "tokenFString")
                        UserDefaults.standard.removeObject(forKey:"userId")
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.logout()
                    }
                    
                }else{
                    IJProgressView.shared.hideProgressView()
                    alert(Constant.shared.appTitle, message: self.message, view: self)
                }
            }
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
            print(error)
        }
    }
    
    @IBAction func ageSliderFunction(_ sender: Any) {
        
        _ = Int((sender as! UISlider).value)
        //              self.ageSlider.minValue = CGFloat(minAge)
        //              self.ageSlider.maxValue = CGFloat(minAge)
    }
    
    
    //MARK:    Range Slider Function
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === ageSlider {
       //     print("\(minValue) - \(maxValue) Years")
            self.minAge = String(format: "%.0f", minValue)
            self.maxAge = String(format: "%.0f", maxValue)
            minAgelabel.text = "Min: \(self.minAge) Years"
            maxAgeLabel.text = "Max: \(self.maxAge) Years"
        } else if slider == locationSlider{
            print("\(minValue) - \(maxValue) Years")
            self.minDistance = String(format: "%.0f", minValue)
            self.maxDistance = String(format: "%.0f", maxValue)
            minDIstanceLabel.text = "Min: \(self.minDistance) miles"
            maxDistanceLabel.text = "Max: \(self.maxDistance) miles"
        }
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
