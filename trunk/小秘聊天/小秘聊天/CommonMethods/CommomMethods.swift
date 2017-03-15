//
//  CommomMethods.swift
//  小秘聊天
//
//  Created by LiWeijie on 2017/3/14.
//  Copyright © 2017年 WeijieLi. All rights reserved.
//

import UIKit

import Alamofire

let CommomMethodsInstance = CommomMethods()

class CommomMethods: NSObject {
    class var sharedInstance : CommomMethods {
        return CommomMethodsInstance
    }
}

extension CommomMethods {
    /**
        由label传入自定义行高
     */
    func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
            
        let statusLabelText: NSString = labelStr as NSString
            
        let size = CGSize(width: width, height: 900)
            
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
            
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.height

    }
    
    func getLabSize(labelStr:String,font:UIFont,width:CGFloat) -> CGSize {
        
        let statusLabelText: NSString = labelStr as NSString
        
        let size = CGSize(width: width, height: 1000)
        
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        
        return strSize
        
    }
    
    //MARK: - POST 请求
    func postRequest(urlString : String, params : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    //let json = JSON(value)
                    //print(json)
                }
            case .failure(let error):
                failture(error)
                print("post错误的信息\(error)")
            }
            
        }
    }

}



