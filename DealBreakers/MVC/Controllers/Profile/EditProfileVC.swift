//
//  EditProfileVC.swift
//  DealBreakers
//
//  Created by Dharmani Apps 001 on 03/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

//UICollectionViewController

import UIKit
import Alamofire
import AlamofireImage
import SDWebImage

import UIKit
import Foundation

class EditProfileVC: UIViewController,UITextFieldDelegate ,ContentDynamicLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var occupationLineLabel: UILabel!
    @IBOutlet weak var schoolLineLabel: UILabel!
    @IBOutlet weak var nameLineLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var occupationNameTF: UITextField!
    @IBOutlet weak var schoolNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    var genderPickerView = UIPickerView()
    var message = String()
    var lat = String()
    var long = String()
    var imageArr = [("",UIImage(named: "add-btn"),"image1"),("",UIImage(named: "add-btn"),"image2"),("",UIImage(named: "add-btn"),"image3"),("",UIImage(named: "add-btn"),"image4"),("",UIImage(named: "add-btn"),"image5"),("",UIImage(named: "add-btn"),"image6")]
    var pickerDataArray = ["Male","Female","InterSex"]
    var selectedValue = ""
    var uploadUserDetails = [UpdateUserData]()
    var userDetails = [String:Any]()
    private var contentFlowLayout: ContentDynamicLayout?
    private var dataItems = [String]()
    private var cellsSizes = [CGSize]()
    var i = Int()
    let imagePicker = UIImagePickerController()
    var imgArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderTF.inputView = genderPickerView
        firstNameTF.delegate = self
        schoolNameTF.delegate = self
        occupationNameTF.delegate = self
        
        imagePicker.delegate = self
        self.getData()
        imagesCollectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
  
    private func setupCollectionView() {
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        contentFlowLayout = InstagramStyleFlowLayout()
        contentFlowLayout?.delegate = self
        contentFlowLayout?.contentPadding = ItemsPadding(horizontal: 20, vertical: 20)
        contentFlowLayout?.cellsPadding = ItemsPadding(horizontal: 20, vertical: 20)
        imagesCollectionView.collectionViewLayout = contentFlowLayout!
        imagesCollectionView.setContentOffset(CGPoint.zero, animated: false)
        imagesCollectionView.reloadData()
    }
    
    private func showLayout(type: FlowLayoutType) {
        
        contentFlowLayout = InstagramStyleFlowLayout()
        contentFlowLayout?.delegate = self
        contentFlowLayout?.contentPadding = ItemsPadding(horizontal: 20, vertical: 20)
        contentFlowLayout?.cellsPadding = ItemsPadding(horizontal: 20, vertical: 20)
        imagesCollectionView.collectionViewLayout = contentFlowLayout!
        imagesCollectionView.setContentOffset(CGPoint.zero, animated: false)
        imagesCollectionView.reloadData()
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        return cellsSizes[indexPath.row]
    }
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    
    
 
    
    func getData() {
        
        IJProgressView.shared.showProgressView()
        self.firstNameTF.text = ""
        self.aboutTextView.text = ""
        self.schoolNameTF.text = ""
        self.occupationNameTF.text = ""
        let signUpUrl = Constant.shared.baseUrl + Constant.shared.userDetaila
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        
        lat = UserDefaults.standard.value(forKey: "lat") as? String ?? ""
        long = UserDefaults.standard.value(forKey: "long") as? String ?? ""
        
        let parms : [String:Any] = ["user_id": id,"present_latitude": lat,"present_longitude": long]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            let result = response as AnyObject
            print(response)
            if let dataDict = result["data"] as? [String:Any]{
                self.firstNameTF.text = dataDict["name"] as? String ?? ""
                self.schoolNameTF.text = dataDict["school"] as? String ?? ""
                print(self.schoolNameTF.text)
                self.occupationNameTF.text = dataDict["occupation"] as? String ?? ""
                let gender = dataDict["gender"] as? String ?? ""
                self.selectedValue = gender
                if gender == "SheMale"{
                    self.genderTF.text = "InterSex"
                }else{
                   self.genderTF.text = gender
                }
                self.aboutTextView.text = dataDict["about"] as? String ?? ""
                if let filterData = dataDict["image"] as? [String]{
                    for i in 0..<filterData.count{
                        self.imageArr[i].0 = filterData[i]
                        self.imageArr[i].1 = UIImage(named: "")
                    }
                    print(self.imageArr)

                    self.imagesCollectionView.reloadData()
                }
            }
            
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            print(error)
            
        }
    }
    
    //MARK:-->  Update User data
    
    func updateUserProfile()  {
        
        let id = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
      
        
        userDetails = ["name": firstNameTF.text ?? "", "school": schoolNameTF.text ?? "", "occupation": occupationNameTF.text ?? "", "about": aboutTextView.text ?? "", "user_id": id, "gender": selectedValue]
        if imageArr.count > 0{
                  for i in 0..<imageArr.count{
                      if imageArr[i].0 != ""{
                          userDetails["image\(i+1)"] = imageArr[i].0
                      }
                  }
              }
        print(userDetails)
        let url = Constant.shared.baseUrl + Constant.shared.editProfile
        IJProgressView.shared.showProgressView()
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in self.userDetails {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            print(multipartFormData)
            for i in 0..<self.imageArr.count{
                if self.imageArr[i].0 != ""{
                    
                }else if self.imageArr[i].1 != UIImage(named: "add-btn"){
                    let imageData1 = self.imageArr[i].1?.jpegData(compressionQuality: 0.3)
                    multipartFormData.append(imageData1!, withName: "image\(i+1)", fileName: "\(String.random(length: 10))", mimeType: "image/jpeg")
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
                        let code = JSON["status"] as! Int
                        let displayMessage = JSON["message"]as?String
                        if code == 1{
                            showAlertMessage(title: Constant.shared.appTitle, message: displayMessage ?? "", okButton: "OK", controller: self) {
                               self.navigationController?.popViewController(animated: true)
                            }
                        }else{
                           alert(Constant.shared.appTitle, message: displayMessage ?? "", view: self)
                        }
                    }
                case .failure(let error): break
                    // error handling
                }
                self.userDetails.removeAll()
//                let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
//                let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//                self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
        
    
    
    
    private let kContenCellIdentifier = "ContentCellIdentifier"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContenCellIdentifier, for: indexPath) as! imagesCollectionViewCell
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(removeBtnAction(_:)), for: .touchUpInside)
        cell.isHidden = false
        if imageArr[indexPath.row].0 != ""{
            let userImage = imageArr[indexPath.row].0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            cell.addImages.sd_setImage(with: URL.init(string: userImage), placeholderImage: #imageLiteral(resourceName: "icon_pp"), options: SDWebImageOptions.refreshCached, completed: nil)
        }else{
            cell.addImages.image = imageArr[indexPath.row].1
        }
      //  cell.addImages.image = imageArr[indexPath.row]
        if imageArr[indexPath.row].0 == "" && imageArr[indexPath.row].1 == UIImage(named: "add-btn"){
            cell.addButton.isHidden = true
        }else{
            cell.addButton.isHidden = false
        }
//        cell.addImages.showImages(imageURL: imgArr[indexPath.row])
        if let kdCollectionView = collectionView as? KDDragAndDropCollectionView {
            
            if let draggingPathOfCellBeingDragged = kdCollectionView.draggingPathOfCellBeingDragged {
                if draggingPathOfCellBeingDragged.item == indexPath.item {
                    cell.isHidden = true
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        i = indexPath.row
         self.ActionSheet()
       }
    
    
    @IBAction func updateButtonAction(_ sender: Any) {
        let selectedElement = imageArr.filter({$0.0 == "" && $0.1 == UIImage(named: "add-btn")})
        if firstNameTF.text == ""{
            ValidateData(strMessage: " Please enter first name")
        }else if genderTF.text == ""{
            ValidateData(strMessage: " Please select gender")
        }else if schoolNameTF.text == ""{
            ValidateData(strMessage: " Please enter school name")
        }else if occupationNameTF.text == ""{
            ValidateData(strMessage: "Enter valid occupation")
        }else if aboutTextView.text == ""{
            ValidateData(strMessage: "Enter valid about us details")
        }else if selectedElement.count == 6{
            ValidateData(strMessage: "Please select atleast one image")
        }else{
        self.updateUserProfile()
        }
    }
    
    @objc func removeBtnAction(_ sender : UIButton){
        i = sender.tag
        imageArr[i].0 = ""
        imageArr[i].1 = UIImage(named: "add-btn")
        imagesCollectionView.reloadData()
    }
    
    //MARK:-->    Upload Images
    
    func ActionSheet() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
           imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

class imagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addImages: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK:-->    Image picker delegate

extension EditProfileVC :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel( _ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[UIImagePickerController.InfoKey.editedImage]
                as? UIImage else {
                    return
            }
        imageArr[i].1 = image
        imageArr[i].0 = ""
         print(imageArr)
        imagesCollectionView.reloadData()
        imagePicker.dismiss(animated: true, completion: nil)

        }
}

//MARK:-->    Image crop delegate

struct UpdateUserData {
    var images : UIImage
    var isImagePresent : Bool
    
    
    init(image: UIImage,isImagePresent : Bool) {
        self.images = image
        self.isImagePresent = isImagePresent
    }
}

extension UIImageView {
    
    func showImages(imageURL: String) {
        AF.request(imageURL, method: .get)
            .validate()
            .responseData(completionHandler: { (responseData) in
                self.image = UIImage(data: responseData.data!)
            })
    }}
extension EditProfileVC : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           pickerDataArray.count
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
               selectedValue = pickerDataArray[row] as String
               if selectedValue == "InterSex"{
                   genderTF.text = selectedValue
                   selectedValue = "SheMale"
                   print(selectedValue)
               }else{
                   genderTF.text = selectedValue
                   print(selectedValue)
               }
       }
       func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
           let label = (view as? UILabel) ?? UILabel()
           label.textColor = .black
           label.textAlignment = .center
           label.font = UIFont(name: "ProximaNova-Semibold", size: 20)
           label.text = pickerDataArray[row]
           return label
       }
       func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
           return 50
       }
}
