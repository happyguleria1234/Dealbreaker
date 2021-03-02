//
//  People.swift
//  Finder
//
//  Created by Rao Mudassar on 11/12/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit

class People: NSObject {
    
    var fb_id:String! = ""
    var first_name:String! = ""
    var birthday:String! = ""
    var gender:String! = ""
    var about_me:String! = ""
    var occuoation:String! = ""
    var school:String! = ""
    var image1:String! = ""
    var image2:String! = ""
    var image3:String! = ""

   
    init(fb_id: String!, first_name: String!,birthday:String!,gender:String!,about_me:String!,occuoation:String!,school : String,image1:String!,image2:String!,image3:String!) {
        
        self.fb_id = fb_id
        self.first_name = first_name
        self.birthday = birthday
        self.gender = gender
        self.about_me = about_me
        self.occuoation = occuoation
        self.image1 = image1
        self.image2 = image2
        self.image3 = image3
    }

}
