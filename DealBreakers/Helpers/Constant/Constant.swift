//
//  Constant.swift
//  WritersRock
//
//  Created by Dharmani Apps 001 on 19/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class Constant: NSObject {
    
    static let shared = Constant()
    
//    let baseUrl = "https://www.dharmani.com/DealBreakers/"
//    let baseUrl = "http://thegoodtoknow.com/WebServices/"
//    let baseUrl = "http://34.67.140.166/DealBreakers/"
   
    let baseUrl = "http://app.thegoodtoknow.com/DealBreakers/"
    
    let appTitle  = "The Good to Know"
    
    
    let fbLogin = "LoginWithFb.php"
    let phoneLogin = "Login.php"
    let checkFbAccountExist = "CheckFbIdExists.php"
    let checkNumberExist = "CheckPhoneNoExists.php"
    let quesionDetails = "GetQAList.php"
    let userDetaila = "GetUserDetailById.php"
    let homeDetails = "HomeScreen.php"
//    let policy = "PrivacyPolicy.html"
    let policy = "PrivacyPolicy.html"
    let termsAndCondition = "TermsOfServices.html"
    let HelpSupport = "HelpAndSupport.html"

//    let termsAndCondition = "TermsOfServices.html"
//    let HelpSupport = "HelpAndSupport.html"
    let contactUS = "ContactUs.php"
    let updateNumber = "UpdatePhoneNumber.php"
    let editProfile = "EditUserProfile.php"
    let editQuestion = "QuesAnsByUser.php"
    let deleteAccount = "DeleteUserProfile.php"
    let getSelectedQuestion = "GetQAList.php"
    let LikeUser = "LikeUser.php"
    let LikedUsersListing = "LikedUsersListing.php"
    let GetChatListing = "Chat/GetChatListing.php"
    let AddChatMessage = "Chat/AddChatMessage.php"
    let ReportUsers = "ReportUsers.php"
    let UnlikeUser = "UnlikeUser.php"
    let UpdateChatSeen = "Chat/UpdateChatSeen.php"
    let Filter = "Filter.php"
    let Logout = "Logout.php"
    let UpdateUserCurrentLocation = "UpdateUserCurrentLocation.php"
    let LoginWithApple = "LoginWithApple.php"
    let CheckAppleExists = "CheckAppleExists.php"
    
//    http://thegoodtoknow.com/WebServices/PrivacyPolicy.html
//    http://thegoodtoknow.com/WebServices/HelpAndSupport.html
//    http://thegoodtoknow.com/WebServices/TermsOfServices.html
    private override init(){}

}
