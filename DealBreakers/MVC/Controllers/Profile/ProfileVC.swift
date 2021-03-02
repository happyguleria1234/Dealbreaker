//
//  ProfileVC.swift
//  DealBreakers
//
//  Created by Dharmani Apps 001 on 11/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileVC: UIViewController {
    
    
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    
    var message = String()
    var name = String()
    var age = String()
    var lat = String()
    var long = String()
    var imgArr = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        profileImage.image = UIImage(named: "img")
     //   profileImage.contentMode = .scaleToFill
//        profileImage.layer.masksToBounds = true
//        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        DispatchQueue.main.async{
            self.profileImage.layer.masksToBounds = true
            self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
        }
//        profileImage.layer.masksToBounds = true
//        profileImage.layer.cornerRadius = profileImage.frame.height/2
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
            let status = response["status"] as? Int
            let msg = response["message"] as? String
            if status == 1{
                let result = response as AnyObject
                if let dataDict = result["data"] as? [String:Any]{
                    print(dataDict)
                    self.name = dataDict["name"] as? String ?? ""
                    self.age = dataDict["age"] as? String ?? ""
                    self.userNamelabel.text = "\(self.name) ,\(self.age)"
                    self.aboutLabel.text = dataDict["about"] as? String ?? ""
                    print(self.name)
                    if let filterData = dataDict["image"] as? [String]{
                        self.imgArr.removeAll()
                        for obj in filterData{
                            
                            self.imgArr.append(obj)
                          //  let imgString =  self.imgArr[0]
                            self.aboutLabel.text = dataDict["about"] as? String ?? ""
                         //   let urlString = "\(self.imgArr[0])"
                            let userImage = self.imgArr[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            let url = URL(string: userImage)
                            UserDefaults.standard.setValue(userImage, forKey: "profilePic")
                            self.profileImage.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_pp"))

                        }
                    }
                }
            }else{
                alert(Constant.shared.appTitle, message: msg ?? "", view: self)
            }
            
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            print(error)
            
        }
    }
    
    @IBAction func gotoShowProfileImageVC(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowProfileImageVC") as! ShowProfileImageVC
        vc.imgArr = imgArr
        self.navigationController?.pushViewController(vc, animated: true)
//        vc.showProfileImage = profileImage
    }
    
    @IBAction func editProfileButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func settingButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }

        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}

extension UIImage {

    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}
