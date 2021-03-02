//
//  ChatSuperCells.swift
//  LeaderBoard
//
//  Created by apple on 6/8/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import UIKit

class ChatSuperCells: UICollectionViewCell {
    
    var chatTextMessageView:ChatTextMessageView!
 //   var chatJoinedMsgView:ChatJoinedMsgView!

  //  var chatImageView: ChatImageView!
    var leadingConstraint:NSLayoutConstraint!
    var trailingConstraint:NSLayoutConstraint!
    var message:Message!
    
    let leftProfileImageView:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 20
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let rightProfileImageView:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 20
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.image = UIImage(named: "person")
        return iv
    }()
    
    let leftnameLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Arial-BoldMT", size: 15)
        lbl.textColor = #colorLiteral(red: 0.0004404069041, green: 0.1274818778, blue: 0.2688113749, alpha: 1)
        return lbl
    }()
    
    let rightNameLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Arial-BoldMT", size: 15)
        lbl.textColor = #colorLiteral(red: 0.0004404069041, green: 0.1274818778, blue: 0.2688113749, alpha: 1)
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let leftDateLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
         if UIDevice().model == "iPad"{
            lbl.font = UIFont(name: "Arial-BoldMT", size: 15)
         }else{
            lbl.font = UIFont(name: "Arial-BoldMT", size: 10)
        }
        lbl.textColor = UIColor.lightGray
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let rightDateLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice().model == "iPad"{
            lbl.font = UIFont(name: "Arial-BoldMT", size: 15)
        }else{
            lbl.font = UIFont(name: "Arial-BoldMT", size: 10)
        }
       // lbl.font = UIFont(name: "Arial-BoldMT", size: 10)
        lbl.textColor = UIColor.lightGray
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()

    let heartButton:UIButton = {
        let hrtBtn = UIButton()
        hrtBtn.translatesAutoresizingMaskIntoConstraints = false
        return hrtBtn
    }()
    
    let likeImage:UIImageView = {
       let likImg = UIImageView()
        likImg.translatesAutoresizingMaskIntoConstraints = false
        likImg.contentMode = ContentMode.scaleAspectFit
        likImg.image = UIImage(named: "heartUnlike")
       return likImg
    }()
    
    let likesButton:UIButton = {
       let likBtn = UIButton()
        likBtn.translatesAutoresizingMaskIntoConstraints = false
        likBtn.setTitle("0 likes", for: .normal)
        likBtn.setTitleColor(.lightGray, for: .normal)
        likBtn.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 11)
        return likBtn
    }()
    
    var userImageUrl:String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let subView = chatTextMessageView{
            subView.removeFromSuperview()
            chatTextMessageView = nil
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if chatTextMessageView != nil{
            let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
            if message.sender_id == id{
                chatTextMessageView.roundCorners(corners: [.topLeft,.bottomRight,.bottomLeft], radius: 15)
            }else{
                chatTextMessageView.roundCorners(corners: [.bottomLeft,.topRight,.bottomRight], radius: 15)
            }
        }

        addSubview(leftProfileImageView)
        addSubview(rightProfileImageView)
        addSubview(leftnameLbl)
        addSubview(rightNameLbl)
        addSubview(leftDateLbl)
        addSubview(rightDateLbl)
        addSubview(likeImage)
        addSubview(heartButton)
        if message != nil{
            self.settingProfilePicConstraints(senderMessage: message)
            self.settingNameLblConstraints(senderMessage: message)
            self.settingDateLblConstraints(senderMessage: message)
        }
    }
    
    func settingProfilePicConstraints(senderMessage:Message) {
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        if senderMessage.sender_id == id{
            self.rightProfileImageView.isHidden = true
            self.leftProfileImageView.isHidden = true
            leftProfileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
            leftProfileImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            leftProfileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            leftProfileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            leftProfileImageView.image = UIImage(named: "person")
        } else {
            self.leftProfileImageView.isHidden = true
            self.rightProfileImageView.isHidden = true
            rightProfileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            rightProfileImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            rightProfileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            rightProfileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            rightProfileImageView.image = UIImage(named: "person")
        }
    }
    
    func settingNameLblConstraints(senderMessage:Message) {
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        if senderMessage.sender_id == id{
            self.rightNameLbl.isHidden = true
            self.leftnameLbl.isHidden = true
            leftnameLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -55).isActive = true
            leftnameLbl.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            leftnameLbl.widthAnchor.constraint(equalToConstant: 1).isActive = true
            leftnameLbl.textAlignment = .right
          //  leftnameLbl.text = senderMessage.name
        }else{
            self.leftnameLbl.isHidden = true
            self.rightNameLbl.isHidden = false
            rightNameLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 55).isActive = true
            rightNameLbl.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
          //  rightNameLbl.widthAnchor.constraint(equalToConstant: 100).isActive = true
            rightNameLbl.heightAnchor.constraint(equalToConstant: 15).isActive = true
            rightNameLbl.textAlignment = .left
          //  rightNameLbl.text = senderMessage.name
        }
    }
    
    func settingDateLblConstraints(senderMessage: Message){
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        if senderMessage.sender_id == id{
            self.rightDateLbl.isHidden = true
            self.leftDateLbl.isHidden = false
            leftDateLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
          //  leftDateLbl.widthAnchor.constraint(equalToConstant: 70).isActive = true
            leftDateLbl.topAnchor.constraint(equalTo: self.topAnchor).isActive  = true
            //  leftnameLbl.heightAnchor.constraint(equalToConstant: 15).isActive = true
            leftDateLbl.textAlignment = .right
         //   if senderMessage.message_time != "akhil"{
         //       self.leftDateLbl.text = senderMessage.message_time.convertDateToString()
//            }else{
//                self.leftDateLbl.text = ""
//            }
        }else{
            self.leftDateLbl.isHidden = true
            self.rightDateLbl.isHidden = false
            rightDateLbl.leadingAnchor.constraint(equalTo:  self.leadingAnchor, constant: 10).isActive = true
           // rightDateLbl.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            rightDateLbl.centerYAnchor.constraint(equalTo: self.rightNameLbl.centerYAnchor).isActive = true
           // rightDateLbl.heightAnchor.constraint(equalToConstant: 15).isActive = true
            rightDateLbl.textAlignment = .left
        //    if senderMessage.message_time != "akhil"{
       //     rightDateLbl.text = senderMessage.message_time.convertDateToString()
//            }else{
//                self.rightDateLbl.text = ""
//            }
        }
    }
    
    
    func registerTextView(text: Message){
       // print(text.message_text.utf8EncodedString())
        chatTextMessageView = ChatTextMessageView.registerTextView()
        chatTextMessageView.updateMessageUI(message: text)
        addSubview(chatTextMessageView)
        chatTextMessageView.translatesAutoresizingMaskIntoConstraints = false
        //chatTextMessageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        let width = UIScreen.main.bounds.width - 140
        [chatTextMessageView?.widthAnchor.constraint(lessThanOrEqualToConstant: width), chatTextMessageView?.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),  chatTextMessageView.heightAnchor.constraint(equalToConstant: estimatedFrameForText(text: text.message).height+40)
            ].forEach({$0?.isActive = true})
        
        chatTextMessageView.textMessageLbl.textColor = .white
        chatTextMessageView.timeLbl.textColor = .white
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        if text.sender_id == id {
            chatTextMessageView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            chatTextMessageView.textMessageLbl.textColor = .black
            chatTextMessageView.timeLbl.textColor = .black
            chatTextMessageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
            chatTextMessageView?.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        }else{
            chatTextMessageView.backgroundColor = #colorLiteral(red: 0.9312694073, green: 0.2674604654, blue: 0.4286250472, alpha: 1)
            chatTextMessageView.textMessageLbl.textColor = .white
            chatTextMessageView.timeLbl.textColor = .white
            chatTextMessageView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
            chatTextMessageView?.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        }
        
    }
//    func registerJoinedTextView(text: Message){
//        // print(text.message_text.utf8EncodedString())
//        chatJoinedMsgView = ChatJoinedMsgView.registerTextView()
//        chatJoinedMsgView.updateMessageUI(message: text)
//        addSubview(chatJoinedMsgView)
//        chatJoinedMsgView.translatesAutoresizingMaskIntoConstraints = false
//        //chatTextMessageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
//        let width = UIScreen.main.bounds.width
//        if UIDevice().model == "iPad"{
//           [chatJoinedMsgView?.widthAnchor.constraint(lessThanOrEqualToConstant: width), chatJoinedMsgView?.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),  chatJoinedMsgView.heightAnchor.constraint(equalToConstant: 80)].forEach({$0?.isActive = true})
//        }else{
//        [chatJoinedMsgView?.widthAnchor.constraint(lessThanOrEqualToConstant: width), chatJoinedMsgView?.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),  chatJoinedMsgView.heightAnchor.constraint(equalToConstant: 30)].forEach({$0?.isActive = true})
//        }
//        chatJoinedMsgView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        chatJoinedMsgView.joinedMSgTextView.textAlignment = .center
//        chatJoinedMsgView.joinedMSgTextView.textColor = .lightGray
//        chatJoinedMsgView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
//        chatJoinedMsgView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
//        chatJoinedMsgView?.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
//    }

    
    func decode(_ s: String) -> String? {
        let data = s.data(using: .nonLossyASCII)!
        return String(data: data, encoding: .utf8)
    }
    func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    //MARK::- Public Method(s)
    public func estimatedFrameForText(text:String) -> CGRect {
        let width = UIScreen.main.bounds.width - 160
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
     //   let size = CGSize(width: self.frame.width - 120, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        var attributes: [NSAttributedString.Key : Any]? = nil
//        if UIDevice().model == "iPad"{
//            attributes = [NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 24.0)!]
//        }else{
//            attributes = [NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 16.0)!]
//            
//        }
      //  attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)]
        attributes = [NSAttributedString.Key.font: UIFont(name: "ProximaNova-Regular", size: 16.0)!]
      //  let attributes = [NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 16.0)!]
        return NSString(string:text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
       // return NSString(string:text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)], context: nil)
    }

    
    
}
