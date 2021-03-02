//
//  Card.swift
//  Example
//
//  Created by HideakiTouhara on 2018/05/17.
//  Copyright © 2018年 HideakiTouhara. All rights reserved.
//

import UIKit
import SDWebImage

class Card: UIView {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextView: UIButton!
    @IBOutlet weak var occupation: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
//    func prepareUI(text: String,text_title: String, img: String) {
//        mealTitle.text = text
//        mealImage.sd_setImage(with: URL(string:img), placeholderImage: UIImage(named: "Unknown"))
//        meal_title.text = text_title
//    }
    func prepareUI(text: String,text_title: String, img: String, gender: String) {
        nameLabel.text = text
        let image1 = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if gender == "Male"{
           image.sd_setImage(with: URL(string:image1), placeholderImage: UIImage(named: "menPH"))
        }else{
            image.sd_setImage(with: URL(string:image1), placeholderImage: UIImage(named: "womenPH"))

        }
       
        occupation.text = text_title
    }
}
