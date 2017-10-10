//
//  SignUpViewController.swift
//  註冊帳號
//
//  Created by 褚宣德 on 2017/9/28.
//  Copyright © 2017年 褚宣德. All rights reserved.
//

import UIKit

class SignUpViewController:UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    // 按下畫面其他地方，收起鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
    
    @IBAction func registerAccount(_ sender: Any) {
        
   
        guard let phone = phone.text, phone != "",
            let emailAddress = emailTextField.text, emailAddress != "",
            let password = passwordTextField.text, password != "" else {

                let alertController = UIAlertController(title: "註冊錯誤", message: "以上欄位不可空白！請確實提供您所要創立的帳號、密碼以及電話.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                present(alertController, animated: true, completion: nil)
                return
        }
        print(phone,password,emailAddress)
        
        let headers = ["cache-control": "no-cache"]
        
        let postData = NSMutableData(data: "account=\(emailAddress)".data(using: String.Encoding.utf8)!)
        postData.append("&password=\(password)".data(using: String.Encoding.utf8)!)
        postData.append("&phone=\(phone)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://kavalanwebservice.niu.edu.tw/threestar/WebService1.asmx/Register")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            
            do {
                let movieArray = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                
                let check = movieArray["check"]! as! String
                print(check)
                
                if check == "OK"{
                    Tool().goToPage(withIdentifier: "loginview", currentViewController: self)
                }
                if check == "repeat"{
                    DispatchQueue.main.async { // Correct
                        Tool().alertMsg(viewController: self, alertTitle:"註冊失敗" , alertMessage:"該帳號已註冊，請嘗試其他帳號、密碼" )
                    }
                }
             
                
                
            } catch let error as NSError {
                    print(error.localizedDescription)
                DispatchQueue.main.async {
                    Tool().alertMsg(viewController: self, alertTitle:"註冊失敗" , alertMessage:"輸入格式或字元有誤，請重新填寫" )
                }
            }
            })
        dataTask.resume()
    }
    
}
        
        
        



    
    

