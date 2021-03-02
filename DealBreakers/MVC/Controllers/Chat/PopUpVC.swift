//
//  PopUpVC.swift
//  DealBreakers
//
//  Created by Dharmani Apps 001 on 07/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

protocol PopViewControllerDelegate: class {
    func dismissPopUP()
}

class PopUpVC: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    var presentIndex = 0
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var reportTableView: UITableView!
    @IBOutlet weak var tableViewHieght: NSLayoutConstraint!
    var chatListArr = [ChatListModel]()
    var userID = ""
    var centerFrame : CGRect!
    var delegates: PopViewControllerDelegate?
    var nameArray = [("Nudity",true),("Voilence",false),("Harassment",false),("Sucide or self-injury",false),("False News",false),("Spam",false),("Unauthorized sales",false),("Hate speech",false),("Terrorism",false),("Others",false)]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = true
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(mytapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
//    Tap Gesture Function
    
    
    @objc func handleTap(_ sender:UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        centerFrame = self.popUpView.frame
    }
    
    @IBAction func submitButtonTap(_ sender: Any) {
        let dialogMessage = UIAlertController(title: Constant.shared.appTitle, message: "Are you sure to submit your report", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             print("Ok button click...")
            self.submitReport()
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
    
    func submitReport()  {
        IJProgressView.shared.showProgressView()
        let signUpUrl = Constant.shared.baseUrl + Constant.shared.ReportUsers
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        let selectedElement = nameArray.filter({$0.1 == true})
        let parms : [String:Any] = ["user_id": id, "reported_id":userID, "reason" : "\(selectedElement[0].0)"]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            print(response)
            let status = response["status"] as? Int
            let message = response["message"] as? String ?? ""
            if status == 1{
                showAlertMessage(title: Constant.shared.appTitle, message: message, okButton: "OK", controller: self) {
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                alert(Constant.shared.appTitle, message: message, view: self)
            }
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
            print(error)
            
        }
        
    }
    
    //    PopUp view Function
    
    
    func presentPopUp()  {
        
        popUpView.frame = CGRect(x: centerFrame.origin.x, y: view.frame.size.height, width: centerFrame.width, height: centerFrame.height)
        popUpView.isHidden = false
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.90, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.popUpView.frame = self.centerFrame
        }, completion: nil)
    }
    
    
    func dismissPopUp(_ dismissed:@escaping ()->())  {
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.90, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.popUpView.frame = CGRect(x: self.centerFrame.origin.x, y: self.view.frame.size.height, width: self.centerFrame.width, height: self.centerFrame.height)
            
        },completion:{ (completion) in
            self.dismiss(animated: false, completion: {
                self.tableView.isHidden = true
                dismissed()
            })
        })
    } 
}


//  Table View Cell class

class reportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectedUnselectedImage: UIImageView!
    @IBOutlet weak var selectUnselectButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


//    Table View Extensions

extension PopUpVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportTableViewCell", for: indexPath) as! reportTableViewCell
        DispatchQueue.main.async {
            self.tableViewHieght.constant = self.reportTableView.contentSize.height
        }
        cell.selectedUnselectedImage.image = (self.nameArray[indexPath.row].1 == true) ? self.returnImage(name: "sel") : self.returnImage(name: "unsel")
        cell.selectUnselectButton.tag = indexPath.row
        cell.selectUnselectButton.addTarget(self, action: #selector(increaseCounter(sender:)), for:  .touchUpInside)
        cell.nameLabel.text = nameArray[indexPath.row].0
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.06
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
    @objc func increaseCounter(sender: UIButton) {
        for i in 0..<nameArray.count{
            nameArray[i].1 = false
        }
        nameArray[sender.tag].1 = true
        reportTableView.reloadData()
    }
    
    
    
    func returnImage(name: String) -> UIImage{
        let image = UIImage(named: name)
        return image!
    }
}

