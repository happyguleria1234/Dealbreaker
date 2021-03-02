//
//  MatchVC.swift
//  DealBreakers
//
//  Created by Dharmani Apps 001 on 03/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MatchVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func sendMessageButtonTap(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
