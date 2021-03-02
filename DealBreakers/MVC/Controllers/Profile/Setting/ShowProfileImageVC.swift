//
//  ShowProfileImageVC.swift
//  DealBreakers
//
//  Created by Vivek Dharmani on 5/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage
import AlamofireImage

class ShowProfileImageVC: UIViewController {
    
    var lat = String()
    var long = String()
    var imgArr = [String]()
    
    @IBOutlet weak var slideView: ImageSlideshow!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.getData()
        
        // Do any additional setup after loading the view.
        var sdWebImageSource = [InputSource]()
        for i in 0..<imgArr.count{
            let userImage = self.imgArr[i].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            sdWebImageSource.append(SDWebImageSource(urlString:userImage)!)
        }
        slideView.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
         slideView.contentScaleMode = UIView.ContentMode.scaleAspectFit
         
         let pageControl = UIPageControl()
        // pageControl.currentPageIndicatorTintColor = UIColor(red: CGFloat(235.0/255.0), green: CGFloat(51.0/255.0), blue: CGFloat(73.0/255.0), alpha: CGFloat(1.0))
         pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.9960784314, green: 0.3411764706, blue: 0.4666666667, alpha: 1)
         pageControl.pageIndicatorTintColor = UIColor.lightGray
         slideView.pageIndicator = pageControl
         
         // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
         slideView.activityIndicator = DefaultActivityIndicator()
        
         
         // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideView.setImageInputs(sdWebImageSource)

    }
    
    func getData() {
        
        IJProgressView.shared.showProgressView()
        let signUpUrl = Constant.shared.baseUrl + Constant.shared.userDetaila
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        lat = UserDefaults.standard.value(forKey: "lat") as? String ?? ""
        long = UserDefaults.standard.value(forKey: "long") as? String ?? ""
        
        let parms : [String:Any] = ["user_id": id,"present_latitude": lat,"present_longitude": long]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            let result = response as AnyObject
            if let dataDict = result["data"] as? NSDictionary{
                print(dataDict)
                if let filterData = dataDict["image"] as? [String]{
                    for obj in filterData{
                        self.imgArr.append(obj)
                       // let imgString =  self.imgArr[0]
                        let userImage = self.imgArr[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        let url = URL(string: userImage)
                        self.profileImage.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
                        print(self.imgArr)
                    }
                }
            }
            
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            print(error)
            
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
