//
//  ChatListVC.swift
//  DealBreakers
//
//  Created by IMac on 6/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
class ChatListCell : UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var lastMsgLbl: UILabel!
    @IBOutlet weak var badgeCountLbl: UILabel!
}
class ChatListVC: UIViewController {

    @IBOutlet weak var chatListTableView: UITableView!
    var chatListArr = [ChatListModel]()
    var chatListArray = [ChatListModel]()
    @IBOutlet weak var profileImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        let profilePic = UserDefaults.standard.value(forKey: "profilePic") as? String ?? ""
        let url = URL(string: profilePic)
        self.profileImg.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_pp"))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async{
            self.profileImg.layer.masksToBounds = true
            self.profileImg.layer.cornerRadius = self.profileImg.frame.height/2
        }
        self.getChatListData()
    }
    func getChatListData() {
         IJProgressView.shared.showProgressView()
        let signUpUrl = Constant.shared.baseUrl + Constant.shared.LikedUsersListing
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        let parms : [String:Any] = ["user_id": id]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            print(response)
            self.chatListArray.removeAll()
            self.chatListArr.removeAll()
            let status = response["status"] as? Int
            let message = response["message"] as? String ?? ""
            if status == 1{
                if let dataArr = response["data"] as? [[String:Any]]{
                    for i in 0..<dataArr.count{
                        self.chatListArray.append(ChatListModel(about: dataArr[i]["about"] as? String ?? "", account_verfication: dataArr[i]["about"] as? String ?? "", address: dataArr[i]["address"] as? String ?? "", age: dataArr[i]["age"] as? String ?? "", badge_count: dataArr[i]["badge_count"] as? String ?? "", created_at_message: dataArr[i]["created_at_message"] as? String ?? "", creation_time: dataArr[i]["creation_time"] as? String ?? "", distance_in_feet: dataArr[i]["distance_in_feet"] as? String ?? "", distance_in_kms: dataArr[i]["distance_in_kms"] as? String ?? "", distance_in_miles: dataArr[i]["distance_in_miles"] as? String ?? "", dob: dataArr[i]["dob"] as? String ?? "", email: dataArr[i]["email"] as? String ?? "", enabled: dataArr[i]["enabled"] as? String ?? "", fb_id: dataArr[i]["fb_id"] as? String ?? "", gender: dataArr[i]["gender"] as? String ?? "", image: dataArr[i]["image"] as? [String] ?? [""], isTextImage: dataArr[i]["isTextImage"] as? String ?? "", last_message: dataArr[i]["last_message"] as? String ?? "", latitude: dataArr[i]["latitude"] as? String ?? "", logged_in_status: dataArr[i]["logged_in_status"] as? String ?? "", longitude: dataArr[i]["longitude"] as? String ?? "", name: dataArr[i]["name"] as? String ?? "", occupation: dataArr[i]["occupation"] as? String ?? "", password: dataArr[i]["password"] as? String ?? "", phone: dataArr[i]["phone"] as? String ?? "", receiver_id: dataArr[i]["receiver_id"] as? String ?? "", room_id: dataArr[i]["room_id"] as? String ?? "", school: dataArr[i]["school"] as? String ?? "", sender_id: dataArr[i]["sender_id"] as? String ?? "", user_id: dataArr[i]["user_id"] as? String ?? ""))
                    }
                    self.chatListArr = self.chatListArray
                }
                self.chatListTableView.isHidden = false
                self.chatListTableView.reloadData()
            }else{
                self.chatListTableView.isHidden = true
             //   alert(Constant.shared.appTitle, message: message, view: self)
            }
            
        }) { (error) in
              IJProgressView.shared.hideProgressView()
            alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
            print(error)
            
        }
    }
    
    @IBAction func searchTextFiledAction(_ sender: UITextField) {
        if sender.text == ""{
            chatListArr = chatListArray
        }else{
            chatListArr = self.chatListArray.filter({ (text) -> Bool in
                let tmp: NSString = text.name as NSString
                let range = tmp.range(of: sender.text!, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
        }
        // arrsearchResults = arrsearchResultsCopy.filter { ($0.exercise_name?.lowercased().contains(txt))! }
        self.chatListTableView.reloadData()
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ChatListVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath as IndexPath) as! ChatListCell
        DispatchQueue.main.async {
            cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.height/2
        }
        cell.nameLbl.text = chatListArr[indexPath.row].name
        cell.lastMsgLbl.text = chatListArr[indexPath.row].last_message
        let urlString = chatListArr[indexPath.row].image[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        cell.profilePic.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "icon_pp"))
        if chatListArr[indexPath.row].badge_count == "0"{
            cell.badgeCountLbl.isHidden = true
        }else{
            cell.badgeCountLbl.isHidden = false
            cell.badgeCountLbl.text = chatListArr[indexPath.row].badge_count
        }
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UIScreen.main.bounds.size.height * 0.095
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.chatListArr = [chatListArr[indexPath.row]]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
struct ChatListModel {
    var about : String
    var account_verfication : String
    var address : String
    var age : String
    var badge_count : String
    var created_at_message : String
    var creation_time : String
    var distance_in_feet : String
    var distance_in_kms : String
    var distance_in_miles : String
    var dob : String
    var email : String
    var enabled : String
    var fb_id : String
    var gender : String
    var image : [String]
    var isTextImage : String
    var last_message : String
    var latitude : String
    var logged_in_status : String
    var longitude : String
    var name : String
    var occupation : String
    var password : String
    var phone : String
    var receiver_id : String
    var room_id : String
    var school : String
    var sender_id : String
    var user_id : String
    

    init(about: String,account_verfication : String, address : String, age : String, badge_count : String, created_at_message : String, creation_time : String, distance_in_feet : String, distance_in_kms : String,distance_in_miles : String,dob : String,email : String,enabled : String,fb_id : String,gender : String,image : [String],isTextImage : String,last_message : String,latitude : String,logged_in_status : String,longitude : String,name : String,occupation : String,password : String,phone : String,receiver_id : String,room_id : String,school : String,sender_id : String,user_id : String) {
        self.about = about
        self.account_verfication = account_verfication
        self.address = address
        self.age = age
        self.badge_count = badge_count
        self.created_at_message = created_at_message
        self.creation_time = creation_time
        self.distance_in_feet = distance_in_feet
        self.distance_in_kms = distance_in_kms
        self.distance_in_miles = distance_in_miles
        self.dob = dob
        self.email = email
        self.enabled = enabled
        self.fb_id = fb_id
        self.gender = gender
        self.image = image
        self.isTextImage = isTextImage
        self.last_message = last_message
        self.latitude = latitude
        self.logged_in_status = logged_in_status
        self.longitude = longitude
        self.name = name
        self.occupation = occupation
        self.password = password
        self.phone = phone
        self.receiver_id = receiver_id
        self.room_id = room_id
        self.school = school
        self.sender_id = sender_id
        self.user_id = user_id
     }
}
