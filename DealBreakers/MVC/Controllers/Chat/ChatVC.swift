//
//  ChatVC.swift
//  DealBreakers
//
//  Created by Dharmani Apps 001 on 07/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Alamofire
import SocketIO
import IQKeyboardManagerSwift

class ChatVC: UIViewController {
    
    @IBOutlet weak var chatCollectionView: UICollectionView!{
            didSet{
                chatCollectionView.register(ChatSuperCells.self, forCellWithReuseIdentifier: "ChatSuperCells")
            }
    }
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    var messagesModel = [Message]()
    var newMsgModel = [Message]()
    var newMsgModel1 = [Message]()
    var pageNumber = 1
    var chatListArr = [ChatListModel]()
    @IBOutlet weak var messageTF: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textviewHeightConstraint: NSLayoutConstraint!
    var isFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTF.delegate = self
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ChatVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses = [ChatVC.self]
         NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        let urlString = chatListArr[0].image[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        profileImage.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "icon_pp"))
        nameLbl.text = chatListArr[0].name
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        chatCollectionView.addSubview(refreshControl)
       getChatList()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let socketConnectionStatus = SocketManger.shared.socket.status
            switch socketConnectionStatus {
            case SocketIOStatus.connected:
                print("socket connected")
                SocketManger.shared.socket.emit("ConncetedChat", self.chatListArr[0].room_id)
                self.newMessageSocketOn()
            case SocketIOStatus.connecting:
                print("socket connecting")
            case SocketIOStatus.disconnected:
                print("socket disconnected")
                SocketManger.shared.socket.connect()
                self.connectSocketOn()
                self.newMessageSocketOn()
            case SocketIOStatus.notConnected:
                print("socket not connected")
                SocketManger.shared.socket.connect()
                self.connectSocketOn()
                self.newMessageSocketOn()
            }
            
        }
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        chatCollectionView.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {

          //Causes the view (or one of its embedded text fields) to resign the first responder status.
          view.endEditing(true)

      }
    @objc func handleKeyboardNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyboardShowing ? keyboardFrame!.height : 0
            
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.scrollEnd()
            })
        }
    }
    func connectSocketOn(){
        SocketManger.shared.onConnect {
            SocketManger.shared.socket.emit("ConncetedChat", self.chatListArr[0].room_id)
            
        }
    }
    func newMessageSocketOn(){
        SocketManger.shared.handleNewMessage { (message) in
            self.messagesModel.append(Message(message_id: message["message_id"] as? String ?? "", sender_id: message["sender_id"] as? String ?? "", receiver_id: message["receiver_id"] as? String ?? "", reply_id: message["receiver_id"] as? String ?? "", room_id: message["room_id"] as? String ?? "", message: message["message"] as? String ?? "", image1: message["image1"] as? String ?? "", image2: message["image2"] as? String ?? "", image3: message["image3"] as? String ?? "", image4: message["image4"] as? String ?? "", image5: message["image5"] as? String ?? "", image6: message["image6"] as? String ?? "", image7: message["image7"] as? String ?? "", image8: message["image8"] as? String ?? "", image9: message["image9"] as? String ?? "", image10: message["image10"] as? String ?? "", message_edited: message["message_edited"] as? String ?? "", read_status: message["read_status"] as? String ?? "", edit_refresh_app: message["edit_refresh_app"] as? String ?? "", created_at: message["created_at"] as? String ?? "", updated_at: message["updated_at"] as? String ?? "", in_trash: message["in_trash"] as? String ?? "", message_seen: message["in_trash"] as? String ?? "", reply_for: message["reply_for"] as? [String] ?? [""]))
            self.chatCollectionView.reloadWithoutAnimation()
            self.chatCollectionView.layoutIfNeeded()
           self.scrollEnd()
          //  self.chatSeenMsg()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.profileImage.layer.masksToBounds = true
            self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
        }
        
    }
    func chatSeenMsg(){
      //  IJProgressView.shared.showProgressView()
        let signUpUrl = Constant.shared.baseUrl + Constant.shared.UpdateChatSeen
       // let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        let message = messagesModel.last
        let messageID = message?.message_id
        let parms : [String:Any] = ["message_id": messageID ?? ""]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
          // IJProgressView.shared.hideProgressView()
            print(response)
            let status = response["status"] as? Int
            let message = response["message"] as? String ?? ""
            if status == 1{
                
            }else{
             //   alert(Constant.shared.appTitle, message: message, view: self)
            }
        }) { (error) in
            //alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
            print(error)
            
        }
    }
    @IBAction func sendMsgBtnAction(_ sender: UIButton) {
        let textCount = messageTF.text!.trimWhiteSpace
        if textCount.count > 0{
            IJProgressView.shared.showProgressView()
            let url = Constant.shared.baseUrl + Constant.shared.AddChatMessage
            IJProgressView.shared.showProgressView()
            AFWrapperClass.requestPostWithMultiFormData(url, params: generatinSendParameters(), headers: nil, success: { (signUpResponse) in
                print(signUpResponse)
                IJProgressView.shared.hideProgressView()
                let code = signUpResponse["status"] as? Int
                let displayMessage = signUpResponse["message"]as? String
                self.newMsgModel.removeAll()
                if code == 1 {
                    self.messageTF.resignFirstResponder()
                    self.messageTF.text = ""
                    self.textviewHeightConstraint.constant = 40
                    if let data = signUpResponse["data"] as? [[String:Any]]{
                        SocketManger.shared.socket.emit("newMessage",self.chatListArr[0].room_id,data[0])
                        self.messagesModel.append(Message(message_id: data[0]["message_id"] as? String ?? "", sender_id: data[0]["sender_id"] as? String ?? "", receiver_id: data[0]["receiver_id"] as? String ?? "", reply_id: data[0]["reply_id"] as? String ?? "", room_id: data[0]["room_id"] as? String ?? "", message: data[0]["message"] as? String ?? "", image1: data[0]["image1"] as? String ?? "", image2: data[0]["image2"] as? String ?? "", image3: data[0]["image3"] as? String ?? "", image4: data[0]["image4"] as? String ?? "", image5: data[0]["image5"] as? String ?? "", image6: data[0]["image6"] as? String ?? "", image7: data[0]["image7"] as? String ?? "", image8: data[0]["image8"] as? String ?? "", image9: data[0]["image9"] as? String ?? "", image10: data[0]["image10"] as? String ?? "", message_edited: data[0]["message_edited"] as? String ?? "", read_status: data[0]["read_status"] as? String ?? "", edit_refresh_app: data[0]["edit_refresh_app"] as? String ?? "", created_at: data[0]["created_at"] as? String ?? "", updated_at: data[0]["updated_at"] as? String ?? "", in_trash: data[0]["in_trash"] as? String ?? "", message_seen: data[0]["message_seen"] as? String ?? "", reply_for: data[0]["reply_for"] as? [String] ?? [""]))
                    self.chatCollectionView.reloadWithoutAnimation()
                    self.chatCollectionView.layoutIfNeeded()
                    self.scrollEnd()
                    }
                }else if code == 0 {
                //    alert(Constant.shared.appTitle, message: displayMessage ?? "", view: self)
                }
            }, failure: { (error) in
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
            })
           
                
        }else {
            alert(Constant.shared.appTitle, message: "Please enter message text", view: self)
        }
        
    }
    func generatinSendParameters() -> [String:AnyObject] {
        var parameters:[String:AnyObject] = [:]
        parameters["room_id"] = chatListArr[0].room_id as AnyObject
        parameters["message"] = self.messageTF.text as AnyObject
        parameters["sender_id"] = chatListArr[0].sender_id as AnyObject
        parameters["receiver_id"] = chatListArr[0].receiver_id as AnyObject
        print(parameters)
        return parameters
    }
    @IBAction func reportButtonTap(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Choose An Action", preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "REPORT \(chatListArr[0].name.uppercased())", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("report")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC
            vc.chatListArr = self.chatListArr
            vc.userID = self.chatListArr[0].user_id
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        })
        reportAction.setValue(#colorLiteral(red: 0.9312694073, green: 0.2674604654, blue: 0.4286250472, alpha: 1), forKey: "titleTextColor")
        let blockAction = UIAlertAction(title: "UNMATCH", style: .default, handler:
        {
            (alertAction: UIAlertAction!) -> Void in
            // self.reportAction()
            showMessage(title: Constant.shared.appTitle, message: "Are you sure want to Unmatch this user?", okButton: "OK", cancelButton: "Cancel", controller: self, okHandler: {
                IJProgressView.shared.showProgressView()
                   let signUpUrl = Constant.shared.baseUrl + Constant.shared.UnlikeUser
                   let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
                   let parms : [String:Any] = ["user_id": id, "like_user_id":self.chatListArr[0].user_id]
                   print(parms)
                   AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
                       IJProgressView.shared.hideProgressView()
                       print(response)
                       let status = response["status"] as? Int
                       let message = response["message"] as? String ?? ""
                       if status == 1{
                           showAlertMessage(title: Constant.shared.appTitle, message: message, okButton: "OK", controller: self) {
                               self.navigationController?.popViewController(animated: true)
                           }
                       }else{
                           alert(Constant.shared.appTitle, message: message, view: self)
                       }
                   }) { (error) in
                       IJProgressView.shared.hideProgressView()
                       alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                       print(error)
                       
                   }
            }) {

            }
            print("Block")
        })
        blockAction.setValue(#colorLiteral(red: 0.9312694073, green: 0.2674604654, blue: 0.4286250472, alpha: 1), forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            //print("Cancelled")
        })
        optionMenu.addAction(reportAction)
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(blockAction)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    @IBAction func backButtonAction(_ sender: Any) {
        if isFrom == "push"{
            appDelegate().getLoggedUser()
        }else{
            IJProgressView.shared.showProgressView()
            let signUpUrl = Constant.shared.baseUrl + Constant.shared.UpdateChatSeen
            let message = messagesModel.last
            let messageID = message?.message_id
            let parms : [String:Any] = ["message_id": messageID ?? ""]
            print(parms)
            AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
                print(response)
                IJProgressView.shared.hideProgressView()
                let status = response["status"] as? Int
             //   let message = response["message"] as? String ?? ""
                if status == 1{
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }) { (error) in
                print(error)
                IJProgressView.shared.hideProgressView()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @objc func doSomething(refreshControl: UIRefreshControl) {
          pageNumber = pageNumber+1
          getChatList()
          refreshControl.endRefreshing()
      }
    func getChatList(){
           let url = Constant.shared.baseUrl + Constant.shared.GetChatListing
           IJProgressView.shared.showProgressView()
           AFWrapperClass.requestPostWithMultiFormData(url, params: generatingParameters(), headers: nil, success: { (signUpResponse) in
               print(signUpResponse)
                IJProgressView.shared.hideProgressView()
               let code = signUpResponse["status"] as? String
               let displayMessage = signUpResponse["message"]as? String
               self.newMsgModel.removeAll()
               if code == "1" {
                 //  self.messageTextView.isHidden = false
                 //  self.sendBtn.isHidden = false
                   if let allMsgs = signUpResponse["data"] as? [[String:Any]] {
                       for i in 0..<allMsgs.count{
                           self.newMsgModel.append(Message(message_id: allMsgs[i]["message_id"] as? String ?? "", sender_id: allMsgs[i]["sender_id"] as? String ?? "", receiver_id: allMsgs[i]["receiver_id"] as? String ?? "", reply_id: allMsgs[i]["reply_id"] as? String ?? "", room_id: allMsgs[i]["room_id"] as? String ?? "", message: allMsgs[i]["message"] as? String ?? "", image1: allMsgs[i]["image1"] as? String ?? "", image2: allMsgs[i]["image2"] as? String ?? "", image3: allMsgs[i]["image3"] as? String ?? "", image4: allMsgs[i]["image4"] as? String ?? "", image5: allMsgs[i]["image5"] as? String ?? "", image6: allMsgs[i]["image6"] as? String ?? "", image7: allMsgs[i]["image7"] as? String ?? "", image8: allMsgs[i]["image8"] as? String ?? "", image9: allMsgs[i]["image9"] as? String ?? "", image10: allMsgs[i]["image10"] as? String ?? "", message_edited: allMsgs[i]["message_edited"] as? String ?? "", read_status: allMsgs[i]["read_status"] as? String ?? "", edit_refresh_app: allMsgs[i]["edit_refresh_app"] as? String ?? "", created_at: allMsgs[i]["created_at"] as? String ?? "", updated_at: allMsgs[i]["updated_at"] as? String ?? "", in_trash: allMsgs[i]["in_trash"] as? String ?? "", message_seen: allMsgs[i]["message_seen"] as? String ?? "", reply_for: allMsgs[i]["message_seen"] as? [String] ?? [""]))
                       }
                         self.newMsgModel = self.newMsgModel.reversed()
                    self.newMsgModel1 = self.messagesModel
                    self.messagesModel = self.newMsgModel
                    for i in 0..<self.newMsgModel1.count{
                        self.messagesModel.append(self.newMsgModel1[i])
                    }
                       if self.messagesModel.count > 0{
                           self.chatCollectionView.reloadWithoutAnimation()
                           self.chatCollectionView.layoutIfNeeded()
                        if self.pageNumber == 1{
                            self.scrollEnd()
                            self.chatSeenMsg()
                        }
                       }
                   }
               }else if code == "0" {
                if self.pageNumber == 1{
                   // alert(Constant.shared.appTitle, message: displayMessage ?? "", view: self)
                }
               }
           }, failure: { (error) in
                IJProgressView.shared.hideProgressView()
               alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
           })
       }
    func generatingParameters() -> [String:AnyObject] {
        var parameters:[String:AnyObject] = [:]
        parameters["room_id"] = chatListArr[0].room_id as AnyObject
        parameters["page_no"] = "\(pageNumber)" as AnyObject
        parameters["sender_id"] = chatListArr[0].sender_id as AnyObject
        parameters["receiver_id"] = chatListArr[0].receiver_id as AnyObject
        print(parameters)
        return parameters
    }
    func scrollEnd(){
          let lastItemIndex = self.chatCollectionView.numberOfItems(inSection: 0) - 1
          let indexPath:IndexPath = IndexPath(item: lastItemIndex, section: 0)
          self.chatCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
      }
}
extension ChatVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messagesModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatSuperCells", for: indexPath) as! ChatSuperCells
        let chatMsgData =  self.messagesModel[indexPath.item]
        cell.message = chatMsgData
        if chatMsgData.message != "" {
            cell.registerTextView(text: chatMsgData)
        }
       // cell.userImageUrl = ""
        cell.contentView.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(messagesModel.count)
        let chatMsgData = messagesModel[indexPath.item]
        var height:CGFloat = 40
        let padding:CGFloat = 60
        let screenSize = UIScreen.main.bounds.width
        let text = chatMsgData.message
        height = estimatedFrameForText(text: text).height + padding
       // print("Chat message Height\(height)::::::::::")
        return CGSize(width: screenSize, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
    }
    //MARK::- Public Method(s)
    public func estimatedFrameForText(text:String) -> CGRect {
        let width = UIScreen.main.bounds.width - 160
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        var attributes: [NSAttributedString.Key : Any]? = nil
//        if UIDevice().model == "iPad"{
//            attributes = [NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 24.0)!]
//        }else{
//            attributes = [NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 16.0)!]
//        }
       // attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)]
        attributes = [NSAttributedString.Key.font: UIFont(name: "ProximaNova-Regular", size: 16.0)!]
        return NSString(string:text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
   
    func splitStringToArray(operatedString: String)->[String]{
        let array = operatedString.components(separatedBy: ",")
        return array
    }
}

extension UINavigationController {
    func customPopView(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
}
extension UICollectionView {
    func reloadWithoutAnimation(){
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        self.reloadData()
        CATransaction.commit()
    }
}
extension ChatVC : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height <= 40 {
            textviewHeightConstraint.constant = 40
        }else if textView.contentSize.height <= 100 && textView.contentSize.height > 40 {
            textviewHeightConstraint.constant = textView.contentSize.height
        }else{
             textviewHeightConstraint.constant = 100
        }
    }
}
