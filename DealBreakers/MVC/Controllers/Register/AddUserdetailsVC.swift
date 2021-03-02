//
//  AddUserdetailsVC.swift
//  DealBreakers
//
//  Created by Dharmani Apps 001 on 16/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AddUserdetailsVC: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate{
    
    var pickerDataArray = [String]()
    var selectedValue = String()
    var userFbDetails = [String:Any]()
    @IBOutlet weak var firstNameTextFld: UITextField!
    @IBOutlet weak var emailTextFld: UITextField!
    @IBOutlet weak var occupationTextFld: UITextField!
    @IBOutlet weak var schoolNameTextFld: UITextField!
    @IBOutlet weak var genderTextFld: UITextField!
    @IBOutlet weak var dobTextFld: UITextField!
    @IBOutlet weak var aboutMeTextFld: UITextField!
    @IBOutlet weak var interestedGenderTF: UITextField!
    
    var userDetails = [UserDetails]()
    var date = String()
    var datePicker = UIDatePicker()
    var thePickerView = UIPickerView()
    var interstedGenderPickerView = UIPickerView()
    var emailStr = ""
    var firstNameStr = ""
    var selectedInterstedGender = ""
    var selectedAgree = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerDataArray = ["Male","Female","InterSex"]
        //        genderTextFld.isUserInteractionEnabled = false
        dobTextFld.delegate = self
        print(userFbDetails)
        thePickerView.delegate = self
        thePickerView.dataSource = self
        genderTextFld.inputView = thePickerView
        interstedGenderPickerView.delegate = self
        interstedGenderPickerView.dataSource = self
        interestedGenderTF.inputView = interstedGenderPickerView
        dobTextFld.inputView = datePicker
        datePicker.datePickerMode = .date
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(DonePressed))
        toolBar.setItems([doneButton], animated: true)
        dobTextFld.inputAccessoryView = toolBar
        dobTextFld.inputView = datePicker
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
 //       thePickerView = UIPickerView(frame: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 100)) //Step 2
        
        let loginFrom = UserDefaults.standard.value(forKey: "LoginFrom") as? String
      //  let phone = UserDefaults.standard.value(forKey: "phoneLogin") as? Bool
        if loginFrom == "phone"{
            emailTextFld.text = ""
            firstNameTextFld.text = ""
            
        }else if loginFrom == "fb"{
          //  let phone = UserDefaults.standard.value(forKey: "fbLogin") as? Bool
            emailTextFld.text = emailStr
            firstNameTextFld.text = firstNameStr
        }else if loginFrom == "apple"{
          //  let phone = UserDefaults.standard.value(forKey: "fbLogin") as? Bool
            emailTextFld.text = emailStr
            firstNameTextFld.text = firstNameStr
        }
        
        // Do any additional setup after loading the view.
    }
    @objc func DonePressed(){
        let components = Calendar.current.dateComponents([.year, .month, .day], from: datePicker .date)
        if let day = components.day, let month = components.month, let year = components.year {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            date = formatter.string(from: datePicker.date)
            self.view.endEditing(true)
            self.dobTextFld.text = date
            verifyAge()
        }
    }
    
    //MARK:    Button Actions
    
    @IBAction func continueButtonAction(_ sender: Any) {
        let loginFrom = UserDefaults.standard.value(forKey: "LoginFrom") as? String
        if loginFrom == "phone"{
            self.comesFromPhoneLogin()
        }else if loginFrom == "fb"{
            
            comesFromFbLogin()
        }else if loginFrom == "apple"{
            comesFromFbLogin()
        }
//        let phone = UserDefaults.standard.value(forKey: "phoneLogin") as? Bool
//        if phone == true{
//            self.comesFromPhoneLogin()
//        }else{
//            let phone = UserDefaults.standard.value(forKey: "fbLogin") as? Bool
//            comesFromFbLogin()
//        }
    }
    @IBAction func agreeBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectedAgree = sender.isSelected
        print(selectedAgree)
    }
    @IBAction func termsAndConditionsBtnAction(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Terms_ConditionsVC") as! Terms_ConditionsVC
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    func comesFromFbLogin()  {
        
        if dobTextFld.text == ""{
            
            ValidateData(strMessage: " Please select date of birth")
            
        }else if genderTextFld.text == ""{
            
            ValidateData(strMessage: " Please select gender")
            
        }else if interestedGenderTF.text == ""{
            
            ValidateData(strMessage: " Please select looking for gender")
            
        }else if schoolNameTextFld.text == ""{
            
            ValidateData(strMessage: " Please enter school name")
            
        }else if occupationTextFld.text == ""{
            
            ValidateData(strMessage: "Enter valid occupation")
            
        }else if aboutMeTextFld.text == ""{
            
            ValidateData(strMessage: "Enter valid about us details")
            
        }else if selectedAgree == false{
            
            ValidateData(strMessage: "Please agree terms and conditions")
        }else{
            
            let parms : [String:Any] = ["name":firstNameTextFld.text!,"dob":dobTextFld.text!,"gender":selectedValue,"school":schoolNameTextFld.text!,"occupation":occupationTextFld.text!,"about":aboutMeTextFld.text!,"email":emailTextFld.text!,"interested_in_gender" : selectedInterstedGender]
            print(parms)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddImagesVC") as! AddImagesVC
            vc.fbDetails = userFbDetails
            vc.fbDetails += parms
            print(vc.fbDetails)
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
        
    }
    
    func comesFromPhoneLogin() {
        
//        emailTextFld.text = ""
//        firstNameTextFld.text = ""
        
        if (emailTextFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter email")
            
        } else if isValidEmail(testStr: (emailTextFld.text)!) == false{
            
            ValidateData(strMessage: "Enter valid email")
            
        }else if firstNameTextFld.text == ""{
            
            ValidateData(strMessage: " Please enter first name")
            
        }else if dobTextFld.text == ""{
            
            ValidateData(strMessage: " Please select date of birth")
            
        }else if genderTextFld.text == ""{
            
            ValidateData(strMessage: " Please select gender")
            
        }else if interestedGenderTF.text == ""{
            
            ValidateData(strMessage: " Please select looking for gender")
            
        }else if schoolNameTextFld.text == ""{
            
            ValidateData(strMessage: " Please enter school name")
            
        }else if occupationTextFld.text == ""{
            
            ValidateData(strMessage: "Enter valid occupation")
            
        }else if aboutMeTextFld.text == ""{
            
            ValidateData(strMessage: "Enter valid about us details")
            
        }else if selectedAgree == false{
            
            ValidateData(strMessage: "Please agree terms and conditions")
        }else{
            
            let parms : [String:Any] = ["name":firstNameTextFld.text!,"dob":dobTextFld.text!,"gender":selectedValue,"school":schoolNameTextFld.text!,"occupation":occupationTextFld.text!,"about":aboutMeTextFld.text!,"email":emailTextFld.text!,"interested_in_gender" : selectedInterstedGender]
            print(parms)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddImagesVC") as! AddImagesVC
            self.navigationController?.pushViewController(vc, animated: true)
            vc.fbDetails = userFbDetails
            print(vc.fbDetails)
            vc.fbDetails = parms
        }
    }
    
    
    @IBAction func openPickerButtonAction(_ sender: UIButton) {
        if sender.tag == 1{
          textFieldDidBeginEditing(genderTextFld)
        }else{
          textFieldDidBeginEditing(interestedGenderTF)
        }
    }
    
    
    //MARK: Text field delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
     //   datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
    }
    
//    @objc func dateChanged(_ sender: UIDatePicker) {
//        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
//        if let day = components.day, let month = components.month, let year = components.year {
//
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd/MM/yyyy"
//            date = formatter.string(from: datePicker.date)
//            self.view.endEditing(true)
//            self.dobTextFld.text = date
//            verifyAge()
//        }
//    }
    
    func verifyAge() {
        
        let dateOfBirth = datePicker.date
        let today = Date()
        let gregorian = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        let age = gregorian?.components([.month, .day, .year], from: dateOfBirth, to: today, options:[])
        
        if (age?.year)! < 18 {
            
            alert(Constant.shared.appTitle, message: "Age should me greater then 18", view: self)
            dobTextFld.text = ""
            //            txtAgeConfirmation.textColor = UIColor.red
            
        } else if (age?.year)! > 18 {
            
            self.dobTextFld.text = date
            
            //            txtAgeConfirmation.textColor = UIColor.black
            
        }
    }
    
    //MARK:    Picker View Methods
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerDataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == thePickerView{
            selectedValue = pickerDataArray[row] as String
            if selectedValue == "InterSex"{
                genderTextFld.text = selectedValue
             //   thePickerView.isHidden = true
                selectedValue = "SheMale"
                print(selectedValue)
            }else{
                genderTextFld.text = selectedValue
             //   thePickerView.isHidden = true
                print(selectedValue)
            }
        }else{
            selectedInterstedGender  = pickerDataArray[row] as String
            if selectedInterstedGender == "InterSex"{
                interestedGenderTF.text = selectedInterstedGender
               // thePickerView.isHidden = true
                selectedInterstedGender = "SheMale"
                print(selectedInterstedGender)
            }else{
                interestedGenderTF.text = selectedInterstedGender
              //  thePickerView.isHidden = true
                print(selectedInterstedGender)
            }
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "ProximaNova-Semibold", size: 20)
        label.text = pickerDataArray[row]
        return label
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}

struct UserDetails {
    var email : String
    var firstName : String
    var dob : Int
    var gender : String
    var school : String
    var about : String
    init(email : String, firstName : String, dob : Int, gender : String, school : String, about : String) {
        self.email = email
        self.firstName = firstName
        self.dob = dob
        self.gender = gender
        self.school = school
        self.about = about
    }
}

extension UIViewController {
    
    func ValidateData(strMessage: String)
    {
        let alert = UIAlertController(title: Constant.shared.appTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

