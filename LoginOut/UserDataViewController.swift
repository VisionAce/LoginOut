//
//  UserDataViewController.swift
//  註冊帳號
//
//  Created by 褚宣德 on 2017/10/4.
//  Copyright © 2017年 褚宣德. All rights reserved.
//

import UIKit

class UserDataViewController:UIViewController{
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var accountlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userid = userDefault.string(forKey: "getuserid")!
        let account = userDefault.string(forKey:"account")!
    
        print(userid)
        print(account)
        
        DispatchQueue.main.async{
            self.accountlabel.text = account
        }
        
        
        
        let headers = ["cache-control": "no-cache"]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://kavalanwebservice.niu.edu.tw/threestar/WebService1.asmx/Total_point?id=\(userid)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            do {
                let movieArray = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                
                let point = movieArray["point"]! as! String
                print(point)
               DispatchQueue.main.async {
                 self.points.text = point
                 self.points.isHidden = false
                }
            }
                //伺服器回傳的錯誤訊息
                catch let error as NSError {
                print(error.localizedDescription)
            }
        })
        
        dataTask.resume()
        
        
        
        
    }
    @IBAction func logout(_ sender: Any) {
        
        DispatchQueue.main.async {
           Tool().goToPage(withIdentifier: "loginview", currentViewController: self)
            
            //判斷是否為登入狀態
            userDefault.set(false, forKey: "isLogin")
            //同步
            userDefault.synchronize()
            
        }
        
    }
    
    
}
