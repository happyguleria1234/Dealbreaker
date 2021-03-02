//
//  QuestionsPreviewVC.swift
//  DealBreakers
//
//  Created by IMac on 7/1/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class QuestionsPreviewVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
    @IBAction func nextBtnAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
