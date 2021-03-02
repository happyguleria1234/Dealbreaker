//
//  ProfileDetailsVC.swift
//  DealBreakers
//  Created by Dharmani Apps 001 on 28/02/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SDWebImage
import ImageSlideshow

class ProfileDetailsVC: UIViewController {
    
    var lat = String()
    var long = String()
    var userId = ""
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameAgeLbl: UILabel!
    @IBOutlet weak var milesLbl: UILabel!
    @IBOutlet weak var schoolLbl: UILabel!
    @IBOutlet weak var occupationLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var reportUserBtn: UIButton!
    @IBOutlet weak var slideView: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK:-->    Home API
        
    func getData() {
        
        IJProgressView.shared.showProgressView()
        let signUpUrl = Constant.shared.baseUrl + Constant.shared.userDetaila
        var id = ""
        if userId == ""{
          id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        }else{
           id = userId
        }
        
        lat = UserDefaults.standard.value(forKey: "lat") as? String ?? ""
        long = UserDefaults.standard.value(forKey: "long") as? String ?? ""
        
        let parms : [String:Any] = ["user_id": id,"present_latitude": lat,"present_longitude": long]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            print(response)
            if let dataDict = response["data"] as? [String:Any]{
                print(dataDict)
                let name = dataDict["name"] as? String ?? ""
                let age = dataDict["age"] as? String ?? ""
                self.reportUserBtn.setTitle("REPORT \(name.uppercased())", for: .normal)
                self.nameAgeLbl.text = name + ", " + age
                self.occupationLbl.text = dataDict["occupation"] as? String ?? ""
                self.locationLbl.text = dataDict["address"] as? String ?? ""
                self.aboutLbl.text = dataDict["about"] as? String ?? ""
                let distance = dataDict["distance_in_miles"] as? String ?? ""
                self.milesLbl.text = " " + distance + " MILES" + " "
                let imageArr = dataDict["image"] as? [String] ?? []
                let userImage = imageArr[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//                let url = URL(string: userImage)
//                self.profileImg.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_pp"))
                self.schoolLbl.text = dataDict["school"] as? String ?? ""
                var sdWebImageSource = [InputSource]()
                for i in 0..<imageArr.count{
                    let userImage = imageArr[i].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    sdWebImageSource.append(SDWebImageSource(urlString:userImage)!)
                }
                self.slideView.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 15))
                self.slideView.contentScaleMode = UIView.ContentMode.scaleAspectFill
                
                let pageControl = UIPageControl()
                // pageControl.currentPageIndicatorTintColor = UIColor(red: CGFloat(235.0/255.0), green: CGFloat(51.0/255.0), blue: CGFloat(73.0/255.0), alpha: CGFloat(1.0))
                pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.9960784314, green: 0.3411764706, blue: 0.4666666667, alpha: 1)
                pageControl.pageIndicatorTintColor = UIColor.lightGray
                self.slideView.pageIndicator = pageControl
                
                // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
                self.slideView.activityIndicator = DefaultActivityIndicator()
                
                
                // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
                self.slideView.setImageInputs(sdWebImageSource)
            }
            
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            print(error)
            
        }
    }
    
    @IBAction func reportButtonTap(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.userID = userId
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func backbuttonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func likeButtonAction(_ sender: Any) {
        IJProgressView.shared.showProgressView()
        let signUpUrl = Constant.shared.baseUrl + Constant.shared.LikeUser
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        let parms : [String:Any] = ["user_id": id,"like_user_id": userId]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            print(response)
            let status = response["status"] as? Int
            let msg = response["message"] as? String ?? ""
            if status == 1{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            print(error)
            
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
