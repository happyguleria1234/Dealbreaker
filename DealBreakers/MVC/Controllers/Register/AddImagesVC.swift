//
//  AddImagesVC.swift
//  DealBreakers
//
//  Created by Vivek Dharmani on 3/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class AddImagesVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var addImagesCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var presentIndex = 0
    var imagePicker = UIImagePickerController()
    var allImages = [UploadImages]()
    var fbDetails = [String:Any]()
    var userDetails = [String:Any]()
    var lat = String()
    var long = String()
    var fbID = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        addImagesCollectionView.delegate = self
        addImagesCollectionView.dataSource = self
        
        self.allImages.append(UploadImages(Selected: false, image: UIImage(), isImagePresent: false))
        self.allImages.append(UploadImages(Selected: false, image: UIImage(), isImagePresent: false))
        self.allImages.append(UploadImages(Selected: false, image: UIImage(), isImagePresent: false))
        self.allImages.append(UploadImages(Selected: false, image: UIImage(), isImagePresent: false))
        
        imagePicker.delegate = self
        addImagesCollectionView.reloadData()
        setupLocationManager()
//           locationManager.requestWhenInUseAuthorization()
//           var currentLoc: CLLocation!
//           if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//           CLLocationManager.authorizationStatus() == .authorizedAlways) {
//              currentLoc = locationManager.location
//              print(currentLoc.coordinate.latitude)
//              print(currentLoc.coordinate.longitude)
//            UserDefaults.standard.set("\(currentLoc.coordinate.latitude)", forKey: "lat")
//            UserDefaults.standard.set("\(currentLoc.coordinate.latitude)", forKey: "long")
//           }

        
        // Do any additional setup after loading the view.
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
                   print("locations = \(locationValue)")

                   locationManager.stopUpdatingLocation()
               }
           }

       // Below Mehtod will print error if not able to update location.
           func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
               print("Error")
           }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage]
            as? UIImage else {
                return
        }
        
        allImages[presentIndex].images = image
        allImages[presentIndex].isImagePresent = true
        addImagesCollectionView.reloadData()
                
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.imagePicker = UIImagePickerController()
        dismiss(animated: true, completion: nil)
    }

    
    
    
    //MARK:-->    Upload Images
    
    func showActionSheet(){
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Upload Image", comment: ""), message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        let cancelActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default)
        { action -> Void in
            self.camera()
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: ""), style: .default)
        { action -> Void in
            self.gallery()
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    func camera()
    {
        let myPickerControllerCamera = UIImagePickerController()
        myPickerControllerCamera.delegate = self
        myPickerControllerCamera.sourceType = UIImagePickerController.SourceType.camera
        myPickerControllerCamera.allowsEditing = true
        self.present(myPickerControllerCamera, animated: true, completion: nil)
        
    }
    
    func gallery()
    {
        
        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        self.present(myPickerControllerGallery, animated: true, completion: nil)
        
    }
    
 
    
    //MARK:-->  Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        let loginFrom = UserDefaults.standard.value(forKey: "LoginFrom") as? String
              if loginFrom == "phone"{
                  self.uploadImage()
              }else if loginFrom == "fb"{
                  login()
              }else if loginFrom == "apple"{
                login()
              }
    }
    func login()  {
        
        userDetails += fbDetails
        print(userDetails)
        
        lat = UserDefaults.standard.value(forKey: "lat") as? String ?? ""
        long = UserDefaults.standard.value(forKey: "long") as? String  ?? ""
        userDetails["present_latitude"] = lat
        userDetails["present_longitude"] = long
        userDetails["latitude"] = lat
        userDetails["longitude"] = long
        userDetails["phone"] = ""
        print(userDetails)
        var url = ""
         let loginFrom = UserDefaults.standard.value(forKey: "LoginFrom") as? String
        if loginFrom == "fb"{
            url = Constant.shared.baseUrl + Constant.shared.fbLogin
        }else if loginFrom == "apple"{
          url = Constant.shared.baseUrl + Constant.shared.LoginWithApple
        }
        let filterArray = allImages.filter({$0.isImagePresent == true})
        if filterArray.count <= 0 {
            alert(Constant.shared.appTitle, message: "Please upload atleast one image", view: self)
        }else{
            
            IJProgressView.shared.showProgressView()
            AF.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in self.userDetails {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                print(multipartFormData)
                
                for i in 0..<self.allImages.count{
                    if self.allImages[i].isImagePresent{
                        let imageData1 = self.allImages[i].images.jpegData(compressionQuality: 0.3)
                        multipartFormData.append(imageData1!, withName: "image\(i+1)", fileName: "\(String.random(length: 6))", mimeType: "image/jpeg")
                    }
                }
                
            }, to: url, usingThreshold: UInt64.init(), method: .post, headers: nil, interceptor: nil, fileManager: .default)
                
                .uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                .responseJSON { (response) in
                    print("Succesfully uploaded\(response)")
                    print(response.result)
                    IJProgressView.shared.hideProgressView()
                    switch response.result {
                    case .success(let value):
                        if let JSON = value as? [String: Any] {
                            print(JSON)
                            let status = JSON["status"] as! Int
                            let message = JSON["message"] as? String
                            if status == 1{
                                UserDefaults.standard.set(true, forKey: "tokenFString")
                                let userId = JSON["user_id"] as? String
                                print(userId ?? 0)
                                UserDefaults.standard.set(userId, forKey: "userId")
                                let lat = JSON["latitude"]
                                UserDefaults.standard.set(lat, forKey: "latitude")
                                print(lat ?? 0)
                                let long = JSON["longitude"]
                                UserDefaults.standard.set(long, forKey: "longitude")
                                print(long ?? 0)
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionsPreviewVC") as! QuestionsPreviewVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            }else{
                                alert(Constant.shared.appTitle, message: message ?? "", view: self)
                            }
                        }
                    case .failure(let error):
                      alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                    }
                    self.userDetails.removeAll()
            }
        }
    }
    
    func uploadImage(){
        
        userDetails += fbDetails
        print(userDetails)
        
        lat = UserDefaults.standard.value(forKey: "lat") as? String ?? ""
        long = UserDefaults.standard.value(forKey: "long") as? String ?? ""
        let phoneNumber = UserDefaults.standard.value(forKey: "phoneNumber") as? String ?? ""
        var deviceID = UserDefaults.standard.value(forKey: "device_token") as? String
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
       // let currentLocationData = ["present_latitude":lat,"present_longitude":long,"latitude":lat,"longitude":long,"phone": phoneNumber, "device_token": deviceID,"device_type":"1"]
        userDetails["present_latitude"] = lat
        userDetails["present_longitude"] = long
        userDetails["latitude"] = lat
        userDetails["longitude"] = long
        userDetails["device_token"] = deviceID
        userDetails["device_type"] = "1"
        userDetails["phone"] = phoneNumber
  //      userDetails += currentLocationData as [String : Any]
        print(userDetails)
        
        let url = Constant.shared.baseUrl + Constant.shared.phoneLogin
        IJProgressView.shared.showProgressView()
        
        let filterArray = allImages.filter({$0.isImagePresent == true})
        if filterArray.count <= 0 {
            IJProgressView.shared.hideProgressView()
            alert(Constant.shared.appTitle, message: "Please upload atleast one image", view: self)
        }else{
            AF.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in self.userDetails {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                print(multipartFormData)
                for i in 0..<self.allImages.count{
                    if self.allImages[i].isImagePresent{
                        let imageData1 = self.allImages[i].images.jpegData(compressionQuality: 0.3)
                        multipartFormData.append(imageData1!, withName: "image\(i+1)", fileName: "\(String.random(length: 6))", mimeType: "image/jpeg")
                    }
                }
                
            }, to: url, usingThreshold: UInt64.init(), method: .post, headers: nil, interceptor: nil, fileManager: .default)
                
                .uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                .responseJSON { (response) in
                    print("Succesfully uploaded\(response)")
                    print(response.result)
                    IJProgressView.shared.hideProgressView()
                    switch response.result {
                    case .success(let value):
                        if let JSON = value as? [String: Any] {
                            print(JSON)
                            let status = JSON["status"] as! Int
                            let message = JSON["message"] as? String
                            if status == 1{
                                UserDefaults.standard.set(true, forKey: "tokenFString")
                                let userId = JSON["user_id"] as? String
                                print(userId ?? 0)
                                UserDefaults.standard.set(userId, forKey: "userId")
                                let lat = JSON["latitude"]
                                UserDefaults.standard.set(lat, forKey: "latitude")
                                print(lat ?? 0)
                                let long = JSON["longitude"]
                                UserDefaults.standard.set(long, forKey: "longitude")
                                print(long ?? 0)
                                UserDefaults.standard.set(false, forKey: "comesFromSettingVc")
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionsPreviewVC") as! QuestionsPreviewVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            }else{
                               alert(Constant.shared.appTitle, message: message ?? "", view: self)
                            }
                        }
                    case .failure(let error):
                        alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                    }
                    self.userDetails.removeAll()
            }
        }
    }
}

class addImagesCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var uploadImages: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension AddImagesVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addImagesCollectionViewCell", for: indexPath) as! addImagesCollectionViewCell
        DispatchQueue.main.async {
            self.collectionViewHeight.constant = self.addImagesCollectionView.contentSize.height
           // self.collectionViewWidth.constant = self.view.bounds.size.width * 0.77
        }
        let data = self.allImages[indexPath.item]
        if data.isImagePresent{
            cell.uploadImages.image = data.images
           // cell.uploadImages.contentMode = .scaleToFill
            
        }else{
            cell.uploadImages.image = UIImage(named: "add-btn")
        }

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? addImagesCollectionViewCell
        self.presentIndex = indexPath.item
        showActionSheet()
        allImages[indexPath.row].selectedCell = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.addImagesCollectionView.frame.size
        return CGSize(width: size.width/2-40
            , height: size.width/2-40)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 40
//    }
}


struct UploadImages {
    var selectedCell : Bool
    var images : UIImage
    var isImagePresent : Bool
    
    
    
    init(Selected: Bool,image: UIImage,isImagePresent : Bool) {
        self.selectedCell = Selected
        self.images = image
        self.isImagePresent = isImagePresent
    }
}


extension String {
    
    static func random(length: Int = 8) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}

extension Dictionary {
    
    static func += (left: inout [Key: Value], right: [Key: Value]) {
        for (key, value) in right {
            left[key] = value
        }
    }
}

