//
//  QuestionVC.swift
//  DealBreakers
//
//  Created by Dharmani Apps 001 on 11/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Alamofire

class QuestionVC: UIViewController {
    
    @IBOutlet weak var countinueView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionsTableView: UITableView!
    var questionArray = [QuestionDetails]()
    var optionArray = [OptionDetails]()
    var questionForPartner = [QuestionDetailsForPartner]()
    var optionsForPartner = [OptionDetailsForPartner]()
    var selectedOptionsArray = [Any]()
    var presentIndex = 0
    var presentIndexForPartner = 0
    var currentIndex = 0
    var presentQuestion:QuestionDetails!
    var presentQusPartner : QuestionDetailsForPartner!
    var message = String()
    var count = 0
    var optionId = [Int]()
    var optionIds = [String]()
    var selectedData = [String : Any]()
    var responseOptionArray = [[String:Any]]()
    var enableValues = Int()
    var enableValuesForPartner = Int()
    var ans = String()
    var allOptions = [String]()
    var setEnable = String()
    var optionID = String()
    var fromSettings = false
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var topLabelHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsTableView.separatorStyle = .none
        
        if fromSettings == true{
            backBtn.isHidden = false
            backImg.isHidden = false
            getSelectdQuestionData()
            topLabelHeight.constant = UIScreen.main.bounds.size.height * 0.1
        }else{
            self.getQuestionDetails()
            topLabelHeight.constant = UIScreen.main.bounds.size.height * 0.015
        }
        
        let nib = UINib(nibName: "QuestionHeader", bundle: nil)
        optionsTableView.register(nib, forHeaderFooterViewReuseIdentifier: "header")
//        self.tableViewHeightConstraint?.constant = CGFloat(tableViewHeight()) + 600
//        self.tableViewHeightConstraint.constant = CGFloat(optionArray.count * 60) + CGFloat(optionsForPartner.count * 60)
//        print(tableViewHeightConstraint)
        //        self.presentQuestion = self.questionArray[presentIndex]
    }
    
    
    //MARK:-->    Button Actions
    
    @IBAction func previousButtonAction(_ sender: Any) {
        if presentIndex > 0{
            presentIndex -= 1
            self.presentQuestion = self.questionArray[presentIndex]
            self.optionsTableView.reloadData()
        }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        if fromSettings == true{
            
            if questionArray[presentIndex].type == "multiple"{
                let filterArray = questionArray[presentIndex].option.filter({$0.selected == true})
                let filterArray2 = questionForPartner[presentIndex].option.filter({$0.selected == true})
                
                if filterArray.count >= 1{
                    if filterArray2.count >= 1 {
                        
                        
                        //                  MARK:->   changes from here
                        
                        let type = filterArray[0].type
                        let id = filterArray[0].id
                        var optionsArray = [String]()
                        var optionsArrayForPartner = [String]()
                        for data in filterArray{
                            let str = String(data.optionID.suffix(1))
                            optionsArray.append(str)
                            print(optionsArray)
                        }
                        
                        for data in filterArray2{
                            let str = String(data.optionID.suffix(1))
                            optionsArrayForPartner.append(str)
                            print(optionsArray)
                        }
                        let newDat = ["question_id":id,"type":type,"answer":optionsArray,"partner_answer":optionsArrayForPartner] as [String : Any]
                        responseOptionArray.append(newDat)
                        
                        //                  MARK:->   changes upto
                        
                        if presentIndex < (questionArray.count - 1){
                            presentIndex += 1
                            self.presentQuestion.option.removeAll()
                            self.count = 0
                            self.presentQuestion = self.questionArray[presentIndex]
                            self.selectedOptionsArray.append(filterArray)
                            self.optionsTableView.reloadData()
                            //
                            let type = filterArray[0].type
                            let id = filterArray[0].id
                            var optionsArray = [String]()
                            for data in filterArray{
                                let str = String(data.optionID.suffix(1))
                                optionsArray.append(str)
                                print(optionsArray)
                            }
                            
                            for data in filterArray2{
                                let str = String(data.optionID.suffix(1))
                                optionsArrayForPartner.append(str)
                                print(optionsArray)
                            }
                            
                            //                            let newDat = ["question_id":id,"type":type,"answer":optionsArray, "partner_answer":optionsArrayForPartner] as [String : Any]
                            //                            responseOptionArray.append(newDat)
                            
                        }else{
                            sendData()
                        }
                    }else{
                        alert(Constant.shared.appTitle, message: "Please select one option for Partner", view: self)
                    }
                }
                else{
                    alert(Constant.shared.appTitle, message: "Please select one option", view: self)
                }
            }else{
                if count  <= 1{
                    let filterArray = questionArray[presentIndex].option.filter({$0.selected == true})
                    let filterArray2 = questionForPartner[presentIndex].option.filter({$0.selected == true})
                    
                    if filterArray.count > 0{
                        if filterArray2.count > 0 {
                            if presentIndex < (questionArray.count - 1){
                                if presentIndexForPartner < (questionForPartner.count - 1){
                                    presentIndexForPartner += 1
                                    self.presentQusPartner.option.removeAll()
                                    self.count = 0
                                    self.presentQusPartner = self.questionForPartner[presentIndex]
                                    self.selectedOptionsArray.append(filterArray)
                                    let id = filterArray[0].id
                                    let type = filterArray[0].type
                                    _ = filterArray[0].optionID
                                    let str = String(filterArray[0].optionID.suffix(1))
                                    let str2 = String(filterArray2[0].optionID.suffix(1))
                                    selectedData = ["question_id":id,"type":type, "answer":str,"partner_answer":str2]
//                                    responseOptionArray.append(selectedData)
                                    print(selectedData)
                                    self.optionsTableView.reloadData()
                                }else{
                                    for i in 0..<self.questionForPartner.count{
                                        if i == self.questionForPartner.count-1{
                                            self.presentQusPartner = self.questionForPartner[i]
                                            self.selectedOptionsArray.append(filterArray2)
                                            let id = filterArray2[0].id
                                            let type = filterArray2[0].type
                                            let str = String(filterArray2[0].optionID.suffix(1))
                                            let str2 = String(filterArray2[0].optionID.suffix(1))
                                            selectedData = ["question_id":id,"type":type, "answer":str, "partner_answer":str2]
//                                            responseOptionArray.append(selectedData)
                                        }
                                    }
                                }
                                presentIndex += 1
                                self.presentQuestion.option.removeAll()
                                self.count = 0
                                self.presentQuestion = self.questionArray[presentIndex]
                                self.selectedOptionsArray.append(filterArray)
                                let id = filterArray[0].id
                                let type = filterArray[0].type
                                _ = filterArray[0].optionID
                                let str = String(filterArray[0].optionID.suffix(1))
                                let str2 = String(filterArray2[0].optionID.suffix(1))
                                selectedData = ["question_id":id,"type":type, "answer":str,"partner_answer":str2]
                                responseOptionArray.append(selectedData)
                                print(selectedData)
                                self.optionsTableView.reloadData()
                            }else{
                                for i in 0..<self.questionArray.count{
                                    if i == self.questionArray.count-1{
                                        self.presentQuestion = self.questionArray[i]
                                        self.selectedOptionsArray.append(filterArray)
                                        let id = filterArray[0].id
                                        let type = filterArray[0].type
                                        let str = String(filterArray[0].optionID.suffix(1))
                                        let str2 = String(filterArray2[0].optionID.suffix(1))
                                        
                                        selectedData = ["question_id":id,"type":type, "answer":str , "partner_answer":str2]
                                        responseOptionArray.append(selectedData)
                                    }
                                }
                                sendData()
                            }
                        }else{
                            alert(Constant.shared.appTitle, message: "Please select one option for Partner", view: self)
                        }
                    }else{
                        alert(Constant.shared.appTitle, message: "Please select one option", view: self)
                    }
                }else{
                    alert(Constant.shared.appTitle, message: "Please select only one option", view: self)
                }
            }
            
        }else{
            
            if questionArray[presentIndex].type == "multiple"{
                let filterArray = questionArray[presentIndex].option.filter({$0.selected == true})
                let filterArray2 = questionForPartner[presentIndex].option.filter({$0.selected == true})
                if filterArray.count >= 1{
                    if filterArray2.count >= 1 {
                        
                        //                MARK:-> changes from here
                        let type = filterArray[0].type
                        let id = filterArray[0].id
                        var optionsArray = [String]()
                        var optionsArrayForPartner = [String]()
                        for data in filterArray{
                            let str = String(data.optionID.suffix(1))
                            optionsArray.append(str)
                            print(optionsArray)
                        }
                        for data in filterArray2{
                            let str = String(data.optionID.suffix(1))
                            optionsArrayForPartner.append(str)
                            print(optionsArray)
                        }
                        let newDat = ["question_id":id,"type":type,"answer":optionsArray,"partner_answer":optionsArrayForPartner] as [String : Any]
                        responseOptionArray.append(newDat)
                        
                        //                MARK:-> changes upto
                        
                        if presentIndex < (questionArray.count - 1){
                            presentIndex += 1
                            self.presentQuestion.option.removeAll()
                            self.count = 0
                            self.presentQuestion = self.questionArray[presentIndex]
                            self.selectedOptionsArray.append(filterArray)
                            self.optionsTableView.reloadData()
                            let type = filterArray[0].type
                            let id = filterArray[0].id
                            var optionsArray = [String]()
                            var optionsArrayForPartner = [String]()
                            for data in filterArray{
                                let str = String(data.optionID.suffix(1))
                                optionsArray.append(str)
                                print(optionsArray)
                            }
                            for data in filterArray2{
                                let str = String(data.optionID.suffix(1))
                                optionsArrayForPartner.append(str)
                                print(optionsArray)
                            }
                            
                            //                            let newDat = ["question_id":id,"type":type,"answer":optionsArray, "partner_answer":optionsArrayForPartner] as [String : Any]
                            //                            responseOptionArray.append(newDat)
                            
                        }else{
                            
                            sendData()
                            
                        }
                    }else{
                        alert(Constant.shared.appTitle, message: "Please select one option for Partner", view: self)
                    }
                }
                else{
                    alert(Constant.shared.appTitle, message: "Please select one option", view: self)
                }
            }else{
                if count  <= 1{
                    let filterArray = questionArray[presentIndex].option.filter({$0.selected == true})
                    let filterArray2 = questionForPartner[presentIndex].option.filter({$0.selected == true})
                    if filterArray.count > 0{
                        if filterArray2.count > 0 {
                            if presentIndex < (questionArray.count - 1){
                                presentIndex += 1
                                self.presentQuestion.option.removeAll()
                                self.count = 0
                                self.presentQuestion = self.questionArray[presentIndex]
                                self.selectedOptionsArray.append(filterArray)
                                let id = filterArray[0].id
                                let type = filterArray[0].type
                                let str = String(filterArray[0].optionID.suffix(1))
                                let str2 = String(filterArray2[0].optionID.suffix(1))
                                selectedData = ["question_id":id,"type":type, "answer":str, "partner_answer":str2]
                                responseOptionArray.append(selectedData)
                                print(selectedData)
                                self.optionsTableView.reloadData()
                            }else{
                                for i in 0..<self.questionArray.count{
                                    if i == self.questionArray.count-1{
                                        self.presentQuestion = self.questionArray[i]
                                        self.selectedOptionsArray.append(filterArray)
                                        let id = filterArray[0].id
                                        let type = filterArray[0].type
                                        let str = String(filterArray[0].optionID.suffix(1))
                                        let str2 = String(filterArray2[0].optionID.suffix(1))
                                        selectedData = ["question_id":id,"type":type, "answer":str,"partner_answer":str2]
                                        responseOptionArray.append(selectedData)
                                    }
                                }
                                for i in 0..<self.questionForPartner.count{
                                    if i == self.questionForPartner.count-1{
                                        self.presentQusPartner = self.questionForPartner[i]
                                        self.selectedOptionsArray.append(filterArray)
                                        let id = filterArray2[0].id
                                        let type = filterArray2[0].type
                                        let str = String(filterArray2[0].optionID.suffix(1))
                                        let str2 = String(filterArray2[0].optionID.suffix(1))
                                        selectedData = ["question_id":id,"type":type, "answer":str,"partner_answer":str2]
                                        responseOptionArray.append(selectedData)
                                    }
                                }
                                sendData()
                            }
                        }else{
                            alert(Constant.shared.appTitle, message: "Please select one option for partner", view: self)
                        }
                    }else{
                        alert(Constant.shared.appTitle, message: "Please select one option", view: self)
                    }
                }else{
                    alert(Constant.shared.appTitle, message: "Please select only one option", view: self)
                }
            }
        }
    }
    
    
    // MARK:--> Functions
    
    func sendData()  {
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        print(responseOptionArray)
        let param = ["user_id": id, "data": responseOptionArray] as [String : Any]
        IJProgressView.shared.showProgressView()
        let editQuestion = Constant.shared.baseUrl + Constant.shared.editQuestion
        AFWrapperClass.requestPOSTURL(editQuestion, params: param, success: { (response) in
            IJProgressView.shared.hideProgressView()
            print("response------>",response)
            if self.fromSettings == true{
                self.message = "Answers updated successfully"
            }else{
                self.message = response["message"] as? String ?? ""
            }
            if let status = response["status"] as? Int{
                if status == 1{
                    IJProgressView.shared.hideProgressView()
                    //     alert(Constant.shared.appTitle, message: self.message, view: self)
                    showAlertMessage(title: Constant.shared.appTitle, message: self.message, okButton: "OK", controller: self) {
                        if self.fromSettings == true{
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                }else{
                    alert(Constant.shared.appTitle, message: self.message, view: self)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            print(error)
            
        }
        
    }
    
    
    func getQuestionDetails() {
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        IJProgressView.shared.showProgressView()
        let signUpWithFBUrl = Constant.shared.baseUrl + Constant.shared.quesionDetails
        let parms : [String:Any] = ["id":id]
        AFWrapperClass.requestUrlEncodedPOSTURL(signUpWithFBUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            print("response------>",response)
            self.message = response["message"] as? String ?? ""
            if let status = response["status"] as? Int{
                if status == 1{
                    if let dataDict = response as?  [String:Any]{
                        
                        if let allQuestionData = dataDict["data"] as? [[String:Any]]{
                            self.questionArray.removeAll()
                            self.optionsForPartner.removeAll()
                            for obj in allQuestionData {
                                self.optionArray.removeAll()
                                self.optionsForPartner.removeAll()
                                for i in 0..<9{
                                    if let answer = obj["answer\(i+1)"] as? String {
                                        self.optionArray.append(OptionDetails(option1: answer, selected: false, optionID: "answer\(i+1)", type: obj["type"] as! String, id: "\(obj["id"] ?? "")",enable: self.enableValues, enableForPartner: self.enableValuesForPartner))
                                        
                                        self.optionsForPartner.append(OptionDetailsForPartner(option1: answer, selected: false, optionID: "answer\(i+1)", type: obj["type"] as! String, id: "\(obj["id"] ?? "")",enable: self.enableValues, enableForPartner: self.enableValuesForPartner))
                                    }
                                }
                                self.questionArray.append(QuestionDetails(question: obj["question"] as! String, option: self.optionArray, type: obj["type"] as! String, id: "\(obj["id"] ?? "")" ,serialNumber: "\(obj["sno"] ?? "")", question1: obj["partner_question"] as! String))
                                
                                self.questionForPartner.append(QuestionDetailsForPartner(question: obj["question"] as! String, option: self.optionsForPartner, type: obj["type"] as! String, id: "\(obj["id"] ?? "")" ,serialNumber: "\(obj["sno"] ?? "")", question1: obj["partner_question"] as! String))
                            }
                            self.presentQuestion = self.questionArray[self.presentIndex]
                            self.presentQusPartner = self.questionForPartner[self.presentIndex]
                            print("questtion array---->",self.questionArray)
                            self.optionsTableView.reloadData()
//                            self.tableViewHeightConstraint.constant = CGFloat(self.optionArray.count * 60) + CGFloat(self.optionsForPartner.count * 60)
//                            print(self.tableViewHeightConstraint)
                            
                        }
                    }
                }else{
//                    self.optionsTableView.isHidden = true
                    self.continueButton.isHidden = true
                    self.countinueView.isHidden = true
                    var yourLabel: UILabel = UILabel()
//                    yourLabel.frame = CGRect(x: 70, y: 300, width: 250, height: 21)
                    yourLabel = UILabel(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 290, height: 70))
                    yourLabel.center.x = self.view.center.x
                    yourLabel.center.y = self.view.center.y
                    yourLabel.textColor = UIColor.black
                    yourLabel.textAlignment = NSTextAlignment.center
                    yourLabel.text = "No questions available "
                    yourLabel.font = UIFont(name: "ProximaNova-Semibold", size: 20)
                    self.view.addSubview(yourLabel)
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
    
    
    func tableViewHeight() -> Int{
        var count = 0
        for i in 0..<questionArray.count{
            count += questionArray[i].option.count
            count += questionArray.count
            count += questionForPartner[i].option.count
            count += questionForPartner.count
            print(count)
        }
        return count
    }
    
    
    func getSelectdQuestionData()  {
        
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        IJProgressView.shared.showProgressView()
        let editQuestionUrl = Constant.shared.baseUrl + Constant.shared.getSelectedQuestion
        let parms : [String:Any] = ["user_id":id]
        AFWrapperClass.requestPOSTURL(editQuestionUrl, params: parms, success: { [self] (response) in
            IJProgressView.shared.hideProgressView()
            print("response------>",response)
            self.message = response["message"] as? String ?? ""
            if let status = response["status"] as? Int{
                if status == 1{
                    if let dataDict = response as?  [String:Any]{
                        
                        if let allQuestionData = dataDict["data"] as? [[String:Any]]{
                            self.questionArray.removeAll()
                            self.questionForPartner.removeAll()
                            for obj in allQuestionData {
                                self.optionArray.removeAll()
                                self.optionsForPartner.removeAll()
                                for i in 0..<9{
                                    if let answer = obj["answer\(i+1)"] as? String {
                                        self.optionArray.append(OptionDetails(option1: answer, selected: false, optionID: "answer\(i+1)", type: obj["type"] as! String, id: "\(obj["id"] ?? "")",enable: self.enableValues, enableForPartner: self.enableValuesForPartner))
                                        
                                        self.optionsForPartner.append(OptionDetailsForPartner(option1: answer, selected: false, optionID: "answer\(i+1)", type: obj["type"] as! String, id: "\(obj["id"] ?? "")",enable: self.enableValues, enableForPartner: self.enableValuesForPartner))
                                        
                                    }
                                }
                                for i in  0..<self.optionArray.count {
                                    self.optionArray[i].enable = Int(obj["setAnsEnable\(i+1)"] as? String ?? "") ?? 0
                                    if let selection = obj["setAnsEnable\(i+1)"] as? String{
                                        if selection == "1"{
                                            self.optionArray[i].selected = true
                                        }else{
                                            self.optionArray[i].selected = false
                                        }
                                    }
                                    
                                }
                                
                                for i in  0..<self.optionsForPartner.count {
                                    self.optionsForPartner[i].enable = Int(obj["setPartnerAnsEnable\(i+1)"] as? String ?? "") ?? 0
                                    if let selection = obj["setPartnerAnsEnable\(i+1)"] as? String{
                                        if selection == "1"{
                                            self.optionsForPartner[i].selected = true
                                        }else{
                                            self.optionsForPartner[i].selected = false
                                        }
                                    }
                                }
                                
                                print(self.optionArray)
                                self.questionArray.append(QuestionDetails(question: obj["question"] as! String, option: self.optionArray, type: obj["type"] as! String, id: "\(obj["id"] ?? "")" ,serialNumber: "\(obj["sno"] ?? "")", question1: obj["partner_question"] as! String))
                                
                                self.questionForPartner.append(QuestionDetailsForPartner(question: obj["question"] as! String, option: self.optionsForPartner, type: obj["type"] as! String, id: "\(obj["id"] ?? "")" ,serialNumber: "\(obj["sno"] ?? "")", question1: obj["partner_question"] as! String))
                            }
                            
                            self.presentQuestion = self.questionArray[self.presentIndex]
                            self.presentQusPartner = self.questionForPartner[self.presentIndex]
                            self.optionsTableView.reloadData()
//                            self.tableViewHeightConstraint.constant = CGFloat(self.optionArray[0].option1.count * 60) + CGFloat(self.optionsForPartner[0].option1.count * 60)
//                            print(self.tableViewHeightConstraint)
                        }
                    }
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

//MARK:-->  TableView Cell Class

class OptionstableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var optionLabel: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK:-->   Table View Delegate and Datasource

extension QuestionVC : UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if questionArray.count > 0 {
            return 2
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.questionArray.count > 0{
            return questionArray[presentIndex].option.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionstableViewCell", for: indexPath) as! OptionstableViewCell
        
        if fromSettings == true{
            
            if indexPath.section == 0{
                let data = questionArray[presentIndex].option[indexPath.row]
                if data.selected{
                    cell.showImage.image = UIImage(named: "pink-border")
                }else{
                    cell.showImage.image = UIImage(named: "gray-border")
                    cell.optionLabel.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
                }
                cell.contentView.backgroundColor = .clear
                cell.optionLabel.text = data.option1
                
            }else{
                
                let data = questionForPartner[presentIndex].option[indexPath.row]
                if data.selected{
                    cell.showImage.image = UIImage(named: "pink-border")
                }else{
                    cell.showImage.image = UIImage(named: "gray-border")
                    cell.optionLabel.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
                }
                cell.contentView.backgroundColor = .clear
                cell.optionLabel.text = data.option1
                
            }
            
        }else{
            
            if indexPath.section == 0{
                let data = questionArray[presentIndex].option[indexPath.row]
                if data.selected{
                    cell.showImage.image = UIImage(named: "pink-border")
                }else{
                    cell.showImage.image = UIImage(named: "gray-border")
                    cell.optionLabel.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
                }
                cell.contentView.backgroundColor = .clear
                cell.optionLabel.text = data.option1
                
            }else{
                
                let data = questionForPartner[presentIndex].option[indexPath.row]
                if data.selected{
                    cell.showImage.image = UIImage(named: "pink-border")
                }else{
                    cell.showImage.image = UIImage(named: "gray-border")
                    cell.optionLabel.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
                }
                cell.contentView.backgroundColor = .clear
                cell.optionLabel.text = data.option1
                
            }
        }
//        DispatchQueue.main.async { [self] in
////            self.tableViewHeightConstraint.constant = CGFloat(self.optionsTableView.contentSize.height)
//            self.tableViewHeightConstraint.constant = CGFloat(self.optionArray.count) * 60 + CGFloat(self.optionsForPartner.count) * 60
//
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell: QuestionHeader? = tableView.dequeueReusableCell(withIdentifier: "header") as? QuestionHeader
        if cell == nil {
            tableView.register(UINib(nibName: "QuestionHeader", bundle: nil), forCellReuseIdentifier: "header")
            cell = tableView.dequeueReusableCell(withIdentifier: "header") as? QuestionHeader
        }
        if section == 0{
            if questionArray.count > 0{
                cell!.questionLabel.text = (questionArray[presentIndex].question)
                cell!.questionLabel.textColor = #colorLiteral(red: 0.9824941754, green: 0.3275985718, blue: 0.4800108075, alpha: 1)
            }
        }else{
            if questionArray.count > 0{
                cell!.questionLabel.text = (questionArray[presentIndex].question1)
                cell!.questionLabel.textColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
            }
            //            cell?.typeLabel.text = questionArray[presentIndex].type == "multiple" ? "Type :Multiple" : "Type :Single"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if fromSettings == true{
            if self.questionArray[presentIndex].type == "multiple"{
                
                if indexPath.section == 0{
                    self.questionArray[presentIndex].option[indexPath.row].selected = !self.questionArray[presentIndex].option[indexPath.row].selected
                    self.currentIndex = indexPath.row
                    tableView.reloadData()
                    if self.questionArray[presentIndex].option[indexPath.row].selected == true{
                        count = count+1
                        self.optionId = [self.currentIndex]
                    }else{
                        count = count-1
                        self.optionId = [self.currentIndex]
                    }
                }else{
                    self.questionForPartner[presentIndex].option[indexPath.row].selected = !self.questionForPartner[presentIndex].option[indexPath.row].selected
                    
                    self.currentIndex = indexPath.row
                    tableView.reloadData()
                    if self.questionForPartner[presentIndex].option[indexPath.row].selected == true{
                        count = count+1
                        self.optionId = [self.currentIndex]
                    }else{
                        count = count-1
                        self.optionId = [self.currentIndex]
                    }
                }
            }else{
                
                
                if indexPath.section == 0{
                    let reqSubArray = self.questionArray[presentIndex].option
                    self.questionArray[presentIndex].option = self.questionArray[presentIndex].option.map({ (answer) -> OptionDetails in
                        var ans = answer
                        ans.selected = false
                        return ans
                    })
                    var subArrayIndexData = reqSubArray[indexPath.row]
                    let newArray = reqSubArray[indexPath.row].selected
                    if reqSubArray[indexPath.row].selected == false{
                        subArrayIndexData.selected = true
                        print(newArray)
                    }else{
                        subArrayIndexData.selected = false
                    }
                    print(subArrayIndexData)
                    self.questionArray[presentIndex].option.remove(at: indexPath.row)
                    self.questionArray[presentIndex].option.insert(subArrayIndexData, at: indexPath.row)
                    tableView.reloadData()
                }else{
                    let reqSubArray = self.questionForPartner[presentIndex].option
                    self.questionForPartner[presentIndex].option = self.questionForPartner[presentIndex].option.map({ (answer) -> OptionDetailsForPartner in
                        var ans = answer
                        ans.selected = false
                        return ans
                    })
                    var subArrayIndexData = reqSubArray[indexPath.row]
                    let newArray = reqSubArray[indexPath.row].selected
                    if reqSubArray[indexPath.row].selected == false{
                        subArrayIndexData.selected = true
                        print(newArray)
                    }else{
                        subArrayIndexData.selected = false
                    }
                    print(subArrayIndexData)
                    self.questionForPartner[presentIndex].option.remove(at: indexPath.row)
                    self.questionForPartner[presentIndex].option.insert(subArrayIndexData, at: indexPath.row)
                    tableView.reloadData()
                }
            }
        }else{
            if self.questionArray[presentIndex].type == "multiple"{
                
                if indexPath.section == 0{
                    self.questionArray[presentIndex].option[indexPath.row].selected = !self.questionArray[presentIndex].option[indexPath.row].selected
                    self.currentIndex = indexPath.row
                    tableView.reloadData()
                    if self.questionArray[presentIndex].option[indexPath.row].selected == true{
                        count = count+1
                        self.optionId = [self.currentIndex]
                    }else{
                        count = count-1
                        self.optionId = [self.currentIndex]
                    }
                }else{
                    self.questionForPartner[presentIndex].option[indexPath.row].selected = !self.questionForPartner[presentIndex].option[indexPath.row].selected
                    
                    self.currentIndex = indexPath.row
                    tableView.reloadData()
                    if self.questionForPartner[presentIndex].option[indexPath.row].selected == true{
                        count = count+1
                        self.optionId = [self.currentIndex]
                    }else{
                        count = count-1
                        self.optionId = [self.currentIndex]
                    }
                }
                
            }else{
                
                
                if indexPath.section == 0{
                    let reqSubArray = self.questionArray[presentIndex].option
                    self.questionArray[presentIndex].option = self.questionArray[presentIndex].option.map({ (answer) -> OptionDetails in
                        var ans = answer
                        ans.selected = false
                        return ans
                    })
                    var subArrayIndexData = reqSubArray[indexPath.row]
                    let newArray = reqSubArray[indexPath.row].selected
                    if reqSubArray[indexPath.row].selected == false{
                        subArrayIndexData.selected = true
                        print(newArray)
                    }else{
                        subArrayIndexData.selected = false
                    }
                    print(subArrayIndexData)
                    self.questionArray[presentIndex].option.remove(at: indexPath.row)
                    self.questionArray[presentIndex].option.insert(subArrayIndexData, at: indexPath.row)
                    tableView.reloadData()
                }else{
                    let reqSubArray = self.questionForPartner[presentIndex].option
                    self.questionForPartner[presentIndex].option = self.questionForPartner[presentIndex].option.map({ (answer) -> OptionDetailsForPartner in
                        var ans = answer
                        ans.selected = false
                        return ans
                    })
                    var subArrayIndexData = reqSubArray[indexPath.row]
                    let newArray = reqSubArray[indexPath.row].selected
                    if reqSubArray[indexPath.row].selected == false{
                        subArrayIndexData.selected = true
                        print(newArray)
                    }else{
                        subArrayIndexData.selected = false
                    }
                    print(subArrayIndexData)
                    self.questionForPartner[presentIndex].option.remove(at: indexPath.row)
                    self.questionForPartner[presentIndex].option.insert(subArrayIndexData, at: indexPath.row)
                    tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

//MARK:-->  Structure

struct QuestionDetails {
    var serialNumber : String
    var question : String
    var question1 : String
    var option : [OptionDetails]
    var type : String
    var id : String
    
    init(question : String, option : [OptionDetails], type : String , id : String, serialNumber : String ,question1 : String) {
        self.question = question
        self.option = option
        self.type = type
        self.id = id
        self.serialNumber = serialNumber
        self.question1 = question1
        
    }
}

struct QuestionDetailsForPartner {
    var serialNumber : String
    var question : String
    var option : [OptionDetailsForPartner]
    var type : String
    var id : String
    var question1 : String
    
    init(question : String, option : [OptionDetailsForPartner], type : String , id : String, serialNumber : String, question1 : String) {
        self.question = question
        self.option = option
        self.type = type
        self.id = id
        self.serialNumber = serialNumber
        self.question1 = question1
    }
}

struct OptionDetails {
    var option1 : String
    var selected : Bool
    var optionID : String
    var type : String
    var id : String
    var enable : Int
    var enableForPartner : Int
    
    init(option1 : String, selected: Bool , optionID : String , type : String , id : String, enable : Int ,enableForPartner : Int) {
        self.option1 = option1
        self.selected = selected
        self.optionID = optionID
        self.type = type
        self.id = id
        self.enable = enable
        self.enableForPartner = enableForPartner
    }
}

struct OptionDetailsForPartner {
    var option1 : String
    var selected : Bool
    var optionID : String
    var type : String
    var id : String
    var enable : Int
    var enableForPartner : Int
    
    init(option1 : String, selected: Bool , optionID : String , type : String , id : String, enable : Int ,enableForPartner : Int) {
        self.option1 = option1
        self.selected = selected
        self.optionID = optionID
        self.type = type
        self.id = id
        self.enable = enable
        self.enableForPartner = enableForPartner
    }
}
