//
//  EditQuestionVC.swift
//  DealBreakers
//
//  Created by Vivek Dharmani on 5/8/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class EditQuestionVC: UIViewController {
    
    var questionsArray = [EditQuestionDetails]()
    var optionsArray = [EditOptionDetails]()
    var selectedOptionsArray = [Any]()
    var presentIndex = 0
    var currentIndex = 0
    var presentQuestion:EditQuestionDetails!
    var message = String()
    var count = 0
    var optionId = [Int]()
    var optionIds = [String]()
    var selectedData = [String : Any]()
    var responseOptionArray = [[String:Any]]()
    var enableValues = Int()
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var editQuestionTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getQuestionDetails()
        let nib = UINib(nibName: "EditQuestionHeader", bundle: nil)
        editQuestionTableView.register(nib, forHeaderFooterViewReuseIdentifier: "header")

        self.tableViewHeightConstraint?.constant = CGFloat(tableViewHeight()) + 200
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func previousButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func nextButtonAction(_ sender: Any) {
    }
    
    func tableViewHeight() -> Int{
        var count = 0
        for i in 0..<questionsArray.count{
            count += questionsArray[i].option.count
            count += questionsArray.count
            print(count)
        }
        return count
    }
    
    func getQuestionDetails() {
           let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
           IJProgressView.shared.showProgressView()
           let signUpWithFBUrl = Constant.shared.baseUrl + Constant.shared.getSelectedQuestion
           let parms : [String:Any] = ["id":id]
           AFWrapperClass.requestUrlEncodedPOSTURL(signUpWithFBUrl, params: parms, success: { (response) in
               IJProgressView.shared.hideProgressView()
               print("response------>",response)
               self.message = response["message"] as? String ?? ""
               if let status = response["status"] as? Int{
                   if status == 1{
                       if let dataDict = response as?  [String:Any]{
                           
                           if let allQuestionData = dataDict["data"] as? [[String:Any]]{
                               self.questionsArray.removeAll()
                               for obj in allQuestionData {
                                   // print(obj)
                                   self.optionsArray.removeAll()
                                   for allOptions in obj {
                                       let key = allOptions.key
                                       
                                       if key.contains("answer") == true{
                                           //   print("our keys are",key)
                                           let value = allOptions.value as? String
                                            for enableValues in obj{
                                                let keys = obj.keys
                                                if keys.contains("setAnsEnable") == true{
                                                    self.enableValues = enableValues.value as! Int
                                                    print(enableValues)
                                                }
                                            }
                                           
                                           self.optionsArray.append(EditOptionDetails(option1: value ?? "", selected: false, optionID: allOptions.key, type: obj["type"] as! String, id: "\(obj["id"] ?? "")",enable: self.enableValues))
                                       }
                                   }
                                   self.questionsArray.append(EditQuestionDetails(question: obj["question"] as! String, option: self.optionsArray, type: obj["type"] as! String, id: "\(obj["id"] ?? "")" ,serialNumber: "\(obj["sno"] ?? "")"))
                               }
                               self.presentQuestion = self.questionsArray[self.presentIndex]
                               //                            print("questtion array---->",self.questionArray)
                               self.editQuestionTableView.reloadData()
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
    func getSelectdQuestionData()  {
        
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        IJProgressView.shared.showProgressView()
        let signUpWithFBUrl = Constant.shared.baseUrl + Constant.shared.getSelectedQuestion
        let parms : [String:Any] = ["id":id]
        AFWrapperClass.requestUrlEncodedPOSTURL(signUpWithFBUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            print("response------>",response)
            self.message = response["message"] as? String ?? ""
            if let status = response["status"] as? Int{
                if status == 1{
                    if let dataDict = response as?  [String:Any]{
                        
                        if let allQuestionData = dataDict["data"] as? [[String:Any]]{
                            self.questionsArray.removeAll()
                            for obj in allQuestionData {
                                // print(obj)
                                self.optionsArray.removeAll()
                                for allOptions in obj {
                                    let key = allOptions.key
                                    if key.contains("answer") == true{
                                        //   print("our keys are",key)
                                        let value = allOptions.value as? String
                                        for enableValues in obj{
                                            let keys = obj.keys
                                            if keys.contains("setAnsEnable") == true{
                                                self.enableValues = enableValues.value as! Int
                                                print(enableValues)
                                            }
                                        }
                                     
                                       self.optionsArray.append(EditOptionDetails(option1: value ?? "", selected: false, optionID: allOptions.key, type: obj["type"] as! String, id: "\(obj["id"] ?? "")", enable: self.enableValues))
                                    }
                                }
                                self.questionsArray.append(EditQuestionDetails(question: obj["question"] as! String, option: self.optionsArray, type: obj["type"] as! String, id: "\(obj["id"] ?? "")" ,serialNumber: "\(obj["sno"] ?? "")"))
                            }
                            print(self.questionsArray)
                            self.presentQuestion = self.questionsArray[self.presentIndex]
                            //                            print("questtion array---->",self.questionArray)
                            self.editQuestionTableView.reloadData()
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

extension EditQuestionVC : UITableViewDelegate,UITableViewDataSource{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.questionsArray.count > 0{
            return questionsArray[presentIndex].option.count
        }else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditQuestionTableViewCell", for: indexPath) as! EditQuestionTableViewCell
        
        let data = questionsArray[presentIndex].option[indexPath.row]
        if questionsArray[presentIndex].option[indexPath.row].enable == 1{
            cell.dataView.backgroundColor = #colorLiteral(red: 0.9822600484, green: 0.3275797367, blue: 0.4710233808, alpha: 1)
            cell.optionName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        if data.selected{
            cell.dataView.backgroundColor = #colorLiteral(red: 0.9822600484, green: 0.3275797367, blue: 0.4710233808, alpha: 1)
            cell.optionName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            cell.dataView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.optionName.textColor = #colorLiteral(red: 0.9824941754, green: 0.3275985718, blue: 0.4800108075, alpha: 1)
        }
        cell.contentView.backgroundColor = .clear
        cell.optionName.text = data.option1
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell: EditQuestionHeader? = tableView.dequeueReusableCell(withIdentifier: "header") as? EditQuestionHeader
        if cell == nil {
            tableView.register(UINib(nibName: "QuestionHeader", bundle: nil), forCellReuseIdentifier: "header")
            cell = tableView.dequeueReusableCell(withIdentifier: "header") as? EditQuestionHeader
        }
        print(questionsArray)
        //               if questionArray.count > 0{
//        let id = questionsArray[presentIndex].serialNumber
//        cell!.optionName.text = "\(id)." + "\(questionsArray[presentIndex].question)"
//        cell?.typeLabel.text = "Type :\(questionsArray[presentIndex].type)"
        //               }
        return cell
    }
    
}

class EditQuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var optionName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


struct EditQuestionDetails {
    var serialNumber : String
    var question : String
    var option : [EditOptionDetails]
    var type : String
    var id : String
    init(question : String, option : [EditOptionDetails], type : String , id : String , serialNumber : String) {
        self.question = question
        self.option = option
        self.type = type
        self.id = id
        self.serialNumber = serialNumber

    }
}

struct EditOptionDetails {
    var option1 : String
    var selected : Bool
    var optionID : String
    var type : String
    var id : String
    var enable : Int
    
    
    init(option1 : String, selected: Bool , optionID : String , type : String , id : String, enable : Int) {
        self.option1 = option1
        self.selected = selected
        self.optionID = optionID
        self.type = type
        self.id = id
        self.enable = enable
    }
}
