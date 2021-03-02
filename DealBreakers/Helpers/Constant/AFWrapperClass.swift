//
// AFWrapperClass.swift
// Attire4hire
//
//  Created by Vivek Dharmani on 06/01/20.
// Copyright © 2020 Apple. All rights reserved.
//
//
import Foundation
import UIKit
import Alamofire
import NVActivityIndicatorView

class AFWrapperClass{
    
    
    class func requestPOSTURL(_ strURL : String, params : Parameters, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"])
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        success(JSON as NSDictionary)
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    failure(error)
                }
        }
    }
    class func requestUrlEncodedPOSTURL(_ strURL : String, params : Parameters, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
           let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: URLEncoding.default, headers: ["Content-Type":"application/x-www-form-urlencoded"])
               .responseJSON { (response) in
                   switch response.result {
                   case .success(let value):
                       if let JSON = value as? [String: Any] {
                        if response.response?.statusCode == 200{
                           success(JSON as NSDictionary)
                        }else if response.response?.statusCode == 400{
                            let error : NSError = NSError(domain: "invalid user details", code: 400, userInfo: [:])
                            failure(error)
                       }
                    }
                   case .failure(let error):
                       let error : NSError = error as NSError
                       failure(error)
                   }
           }
       }
    class func requestGETURL(_ strURL: String, params : [String : AnyObject]?, success:@escaping (AnyObject) -> Void, failure:@escaping (NSError) -> Void) {
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .get, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? Any {
                        success(JSON as AnyObject)
                        print(JSON)
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    failure(error)
                }
        }
    }
    class func requestPostWithMultiFormData(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
           let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
           AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
               case .success(let value):
                   if let JSON = value as? [String: Any] {
                       success(JSON as NSDictionary)
                   }
               case .failure(let error):
                   let error : NSError = error as NSError
                   failure(error)
               }
           }
       }
}

extension UIViewController {
    func isValidUsername(testStr:String) -> Bool
    {
        let emailRegEx = ".*[^A-Za-z].*"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
