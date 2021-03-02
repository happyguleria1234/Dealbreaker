//
//  QuestionHeader.swift
//  DealBreakers
//
//  Created by Dharmani Apps 001 on 11/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class QuestionHeader: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
