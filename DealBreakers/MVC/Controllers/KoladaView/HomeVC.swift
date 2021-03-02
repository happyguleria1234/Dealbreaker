//
//  HomeVC.swift
//  DealBreakers
//
//  Created by Dharmani Apps 001 on 04/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Koloda
import CoreLocation

private var numberOfCards: Int = 5

class HomeVC: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var koladaView: KolodaView!
    var message = String()
    var lat = String()
    var long = String()
    var img1 = String()
    var img2 = String()
    var img3 = String()
    var msg = String()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    var sampleCards = [Card]()
    var nearArray:NSMutableArray = []
    var userArray = [UserDetail]()
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var likeDislikeView: UIView!
    @IBOutlet weak var leftProfilePic: UIImageView!
    @IBOutlet weak var rightProfilePic: UIImageView!
    @IBOutlet weak var matchedView: UIView!
    @IBOutlet weak var msgBadgeLbl: UILabel!
    var chatListArray = [ChatListModel]()
    var cardIndex = 0
    
    
    var images = ["","","","",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalTransitionStyle = UIModalTransitionStyle.partialCurl
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        matchedView.isHidden = true
        bgView.isHidden = true
        likeDislikeView.isHidden = true
        currentLocation = nil
        setupLocationManager()
        getProfileData()
        DispatchQueue.main.async{
            self.profileImg.layer.masksToBounds = true
            self.profileImg.layer.cornerRadius = self.profileImg.frame.height/2
            self.leftProfilePic.layer.masksToBounds = true
            self.leftProfilePic.layer.cornerRadius = self.leftProfilePic.frame.height/2
            self.rightProfilePic.layer.masksToBounds = true
            self.rightProfilePic.layer.cornerRadius = self.rightProfilePic.frame.height/2
        }
    }
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocation == nil {
            currentLocation = locations.last
            locationManager.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            let latitude = String(format: "%.6f", locationValue.latitude)
            let longitude = String(format: "%.6f", locationValue.longitude)
            UserDefaults.standard.set(latitude, forKey: "lat")
            UserDefaults.standard.set(longitude, forKey: "long")
            //    print("locations = \(locationValue)")
            locationManager.stopUpdatingLocation()
            self.getData()
            self.updateLocationApi()
            
        }
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    //MARK:-->    Home API
    
    func getData() {
        
        IJProgressView.shared.showProgressView()
        let signUpUrl = Constant.shared.baseUrl + Constant.shared.homeDetails
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        lat = UserDefaults.standard.value(forKey: "lat") as? String ?? ""
        long = UserDefaults.standard.value(forKey: "long") as? String ?? ""
        
        let parms : [String:Any] = ["user_id": id,"present_latitude": lat,"present_longitude": long]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            print(response)
            let status = response["status"] as? Int
            let verified = response["verified"] as? Int
            self.msg = response["message"] as? String ?? ""
            if verified == 0{
                showAlertMessage(title: Constant.shared.appTitle, message: "Please fill the questions firstly then only you can see the matches", okButton: "OK", controller: self) {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if status == 1{
                    if let result = response as? [String:Any] {
                        self.sampleCards.removeAll()
                        self.userArray.removeAll()
                        self.cardIndex = 0
                        if let dataDict = result["data"] as? [[String:Any]]{
                            print(dataDict)
                            for i in 0..<dataDict.count{
                                if let imageArray = dataDict[i]["image"] as? [String] {
                                    self.img1 = imageArray[0]
                                }
                                self.userArray.append(UserDetail(fb_id: dataDict[i]["fb_id"] as? String ?? "", first_name: dataDict[i]["name"] as? String ?? "", birthday: dataDict[i]["age"] as? String ?? "", gender: dataDict[i]["gender"] as? String ?? "", about_me: dataDict[i]["about"] as? String ?? "", occuoation: dataDict[i]["occupation"] as? String ?? "", school: dataDict[i]["school"] as? String ?? "", image1: self.img1, image2: self.img2, image3: self.img3, user_id: dataDict[i]["user_id"] as? String ?? ""))
                            }
                            self.koladaView.resetCurrentCardIndex()
                            if self.userArray.count > 0{
                                for i in 0..<self.userArray.count{
                                    let card =  Bundle.main.loadNibNamed("Card", owner: self, options: nil)![0] as! Card
                                    card.prepareUI(text:self.userArray[i].first_name+", "+self.userArray[i].birthday,text_title:self.userArray[i].occuoation, img: self.userArray[i].image1, gender: self.userArray[i].gender)
                                    self.sampleCards.append(card)
                                }
                                self.koladaView.isHidden = false
                                self.koladaView.delegate = self
                                self.koladaView.dataSource = self
                                self.koladaView.reloadData()
                            }else{
                                self.koladaView.isHidden = true
                                self.bgView.isHidden = false
                                self.likeDislikeView.isHidden = true
                            }
                        }
                    }else{
                        alert(Constant.shared.appTitle, message: self.msg, view: self)
                    }
                }else{
                    alert(Constant.shared.appTitle, message: self.msg, view: self)
                }
            }
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            print(error)
            alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
        }
    }
    
    func getProfileData() {
        let signUpUrl = Constant.shared.baseUrl + Constant.shared.userDetaila
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        let lat = UserDefaults.standard.value(forKey: "lat") as? String ?? ""
        let long = UserDefaults.standard.value(forKey: "long") as? String ?? ""
        let parms : [String:Any] = ["user_id": id,"present_latitude": lat,"present_longitude": long]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
            let status = response["status"] as? Int
            if status == 1{
                print(response)
                let result = response as AnyObject
                if let dataDict = result["data"] as? [String:Any]{
                    if let newMatch = dataDict["new_match"] as? Int{
                        if newMatch == 1{
                            self.msgBadgeLbl.isHidden = false
                        }else{
                            self.msgBadgeLbl.isHidden = true
                        }
                    }
                    print(dataDict)
                    if let filterData = dataDict["image"] as? [String]{
                        var imgArr = [String]()
                        for obj in filterData{
                            imgArr.append(obj)
                            let userImage = imgArr[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            UserDefaults.standard.setValue(userImage, forKey: "profilePic")
                            let url = URL(string: userImage)
                            self.profileImg.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_pp"))
                        }
                    }
                }
            }else{
            }
            
        }) { (error) in
            print(error)
        }
    }
    func updateLocationApi() {
        let signUpUrl = Constant.shared.baseUrl + Constant.shared.UpdateUserCurrentLocation
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        let lat = UserDefaults.standard.value(forKey: "lat") as? String ?? ""
        let long = UserDefaults.standard.value(forKey: "long") as? String ?? ""
        let parms : [String:Any] = ["user_id": id,"latitude": lat,"longitude": long]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
            print(response)
            let status = response["status"] as? Int
            if status == 1{
            }else{
            }
        }) { (error) in
            print(error)
        }
    }
    
    // MARK:   Buttons Actions
    
    @IBAction func gotoProfileDetailsButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetailsVC") as! ProfileDetailsVC
        print(cardIndex)
        vc.userId =  self.userArray[cardIndex].user_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func chatButtonTap(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func matchViewHiddenBtnAction(_ sender: UIButton) {
        matchedView.isHidden = true
    }
    
    @IBAction func profileButtonTap(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func sendMsgBtnAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.chatListArr = [chatListArray[0]]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:   Button Action For Left Right Swipe
    @IBAction func dislikeBtnAction(_ sender: UIButton) {
        koladaView?.swipe(.left)
    }
    
    @IBAction func likeBtnAction(_ sender: UIButton) {
        koladaView?.swipe(.right)
    }
}

// MARK: KolodaViewDelegate

extension HomeVC: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koladaView.isHidden = true
        bgView.isHidden = false
        likeDislikeView.isHidden = true
    }
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
    }
}

// MARK: KolodaViewDataSource

extension HomeVC: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return sampleCards.count
    }
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .slow
    }
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int){
        likeDislikeView.isHidden = false
    }
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool{
       return false
    }
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return sampleCards[index]
    }
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
     func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        cardIndex = cardIndex + 1
        print("swiped left")
        if direction == SwipeResultDirection.right {
            IJProgressView.shared.showProgressView()
            let signUpUrl = Constant.shared.baseUrl + Constant.shared.LikeUser
            let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
            let parms : [String:Any] = ["user_id": id,"like_user_id": userArray[index].user_id ?? ""]
            print(parms)
            AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                let status = response["status"] as? Int
                self.msg = response["message"] as? String ?? ""
                if status == 1{
                }else if status == 2{
                    if let likedUserData = response["liked_user_data"] as? [String:Any]{
                        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
                        self.chatListArray = [ChatListModel(about: "", account_verfication: "", address: "", age: "", badge_count: "", created_at_message: "", creation_time: "", distance_in_feet: "", distance_in_kms: "", distance_in_miles: "", dob: "", email: "", enabled: "", fb_id: "", gender: "", image: likedUserData["image"] as? [String] ?? [], isTextImage: "", last_message: "", latitude: "", logged_in_status: "", longitude: "", name: likedUserData["name"] as? String ?? "", occupation: "", password: "", phone: "", receiver_id: likedUserData["user_id"] as? String ?? "", room_id: likedUserData["room_id"] as? String ?? "", school: "", sender_id: id, user_id: likedUserData["user_id"] as? String ?? "")]
                        let userImage = self.chatListArray[0].image[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        let url = URL(string: userImage)
                        self.leftProfilePic.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_pp"))
                        let profilePic = UserDefaults.standard.value(forKey: "profilePic") as? String ?? ""
                        let url1 = URL(string: profilePic)
                        self.rightProfilePic.sd_setImage(with: url1, placeholderImage: UIImage(named: "icon_pp"))
                    }
                    self.matchedView.isHidden = false
                }else{
                   alert(Constant.shared.appTitle, message: self.msg, view: self)
                }
            }) { (error) in
                IJProgressView.shared.hideProgressView()
                print(error)
            }
        }
    }
}


struct UserDetail {
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
     var user_id:String! = ""
     init(fb_id: String!, first_name: String!,birthday:String!,gender:String!,about_me:String!,occuoation:String!,school : String,image1:String!,image2:String!,image3:String!,user_id:String!) {
         self.fb_id = fb_id
         self.first_name = first_name
         self.birthday = birthday
         self.gender = gender
         self.about_me = about_me
         self.occuoation = occuoation
         self.image1 = image1
         self.image2 = image2
         self.image3 = image3
         self.user_id = user_id
     }
}
