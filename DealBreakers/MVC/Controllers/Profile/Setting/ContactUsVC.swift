//
//  ContactUsVC.swift
//  DealBreakers
//
//  Created by Vivek Dharmani on 3/23/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController,UITextViewDelegate {
    
    var message = String()
    @IBOutlet weak var contactUSTxtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        contactUSTxtView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//
//        contactUSTxtView.text = ""
//
//    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func contactUsButtonTap(_ sender: Any) {
        
        if contactUSTxtView.text.isEmpty{
            ValidateData(strMessage: "Please enter Message")
        }else{
            addData()
        }
    }
    
    func addData()  {
        IJProgressView.shared.showProgressView()
        let signUpUrl = Constant.shared.baseUrl + Constant.shared.contactUS
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        
        let parms : [String:Any] = ["user_id": id,"content": contactUSTxtView.text!]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            let status = response["status"] as? Int
            self.message = response["message"] as? String ?? ""
            if status == 1{
                self.contactUSTxtView.text = ""
//                alert(Constant.shared.appTitle, message: self.message, view: self)
                showAlertMessage(title: Constant.shared.appTitle, message: self.message, okButton: "Ok", controller: self) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: self.message, view: self)
            }
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            print(error)
        }
    }
}
