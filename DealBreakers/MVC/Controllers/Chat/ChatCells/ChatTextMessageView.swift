//
//  ChatTextMessageView.swift
//  LeaderBoard
//
//  Created by apple on 6/8/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

import UIKit

class ChatTextMessageView: UIView {
    
    @IBOutlet weak var textMessageLbl: UITextView!
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var textMessage_leadingConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var textMessage_trailingConstraints: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    class func registerTextView() -> ChatTextMessageView? {
        if let messageTextView = Bundle.main.loadNibNamed("ChatTextMessageView", owner: self, options: nil)?.first as? ChatTextMessageView{
            return messageTextView
        }
        return nil
    }
    
    func updateMessageUI(message: Message){
        textMessageLbl.text = message.message
        timeLbl.text = message.created_at.convertDateToString()
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        let ownUser = (message.sender_id == id)
      //  print("senderId===> \(message.sender_id)  userId====> \(id)")
        textMessageLbl.textColor = ownUser ? .white : .black
        timeLbl.textColor = ownUser ? .white : .black
        self.backgroundColor = ownUser ? .red : .lightGray
    }
    
    
}
extension String{
    func convertDateToString()->String{
        let str = Double(self)
        let date = Date(timeIntervalSince1970: str!)
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        if !calendar.isDateInToday(date){
            dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
        }
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        if let date = dateFormatter.date(from: self){
//            let reqFormatter = DateFormatter()
//            reqFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
//            reqFormatter.timeZone = .current
//            let reqString = reqFormatter.string(from: date)
//            return reqString
//        }else{
//            return ""
//        }
    }
}
