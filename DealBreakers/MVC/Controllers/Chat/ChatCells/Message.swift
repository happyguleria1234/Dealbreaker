//
//  Message.swift
//  LeaderBoard
//
//  Created by apple on 6/8/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
struct Message {
    let message_id: String
    let sender_id: String
    let receiver_id: String
    let reply_id: String
    let room_id: String
    let message: String
    let image1: String
    let image2: String
    let image3: String
    let image4: String
    let image5: String
    let image6: String
    let image7: String
    let image8: String
    let image9: String
    let image10: String
    let message_edited: String
    let read_status: String
    let edit_refresh_app: String
    let created_at: String
    let updated_at: String
    let in_trash: String
    let message_seen: String
    let reply_for:[String]
  //  let user_detail: [UserDetailsModel]?
    init(message_id: String, sender_id: String, receiver_id:String, reply_id:String, room_id:String, message: String, image1: String, image2: String, image3: String, image4: String, image5: String, image6: String, image7: String, image8: String, image9: String, image10: String, message_edited: String, read_status: String, edit_refresh_app: String, created_at: String, updated_at: String, in_trash: String, message_seen: String, reply_for: [String]) {
        self.message_id = message_id
        self.sender_id = sender_id
        self.receiver_id = receiver_id
        self.reply_id = reply_id
        self.room_id = room_id
        self.message = message
        self.image1 = image1
        self.image2 = image2
        self.image3 = image3
        self.image4 = image4
        self.image5 = image5
        self.image6 = image6
        self.image7 = image7
        self.image8 = image8
        self.image9 = image9
        self.image10 = image10
        self.message_edited = message_edited
        self.read_status = read_status
        self.edit_refresh_app = edit_refresh_app
        self.created_at = created_at
        self.updated_at = updated_at
        self.in_trash = in_trash
        self.message_seen = message_seen
        self.reply_for = reply_for
    }
}
struct UserDetailsModel {
    let name : String
    let user_id : String
    init(name: String,user_id: String) {
        self.name = name
        self.user_id = user_id
       
    }
}
