//
//  ViewController.swift
//  註冊帳號
//
//  Created by 褚宣德 on 2017/9/28.
//  Copyright © 2017年 褚宣德. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // 按下畫面其他地方，收起鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
        self.view.endEditing(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hidesBarsOnTap = true
    }
    
    @IBAction func login(_ sender: Any) {
        
       //判斷帳號密碼是否為空
      guard let emailAddress = emailTextField.text, emailAddress != "",
            let password = passwordTextField.text, password != "" else {
                
                let alertController = UIAlertController(title: "登入錯誤", message: "以上欄位不可空白！", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                present(alertController, animated: true, completion: nil)
                return
        }
        //post到server，做login的動作
        let headers = ["cache-control": "no-cache"]
        
        let postData = NSMutableData(data: "account=\(emailAddress)".data(using: String.Encoding.utf8)!)
        postData.append("&password=\(password)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://kavalanwebservice.niu.edu.tw/threestar/WebService1.asmx/Login")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            //json的解析
            do {
                let movieArray = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                
                let user = movieArray["user"]! as! String
                print(user)
                //當帳號或密碼有錯
                if user == "Failed"{
                    DispatchQueue.main.async { // Correct
                        Tool().alertMsg(viewController: self, alertTitle:"登入失敗" , alertMessage:"帳號或密碼有錯，請重新輸入" )
                    }
                }
                //當帳號密碼正確
                else{
                    
                    //判斷是否為登入狀態
                    userDefault.set(true, forKey: "isLogin")
                    //同步
                    
                    userDefault.setValue(user, forKey: "getuserid")
                    
                    userDefault.setValue(emailAddress, forKey:"account")
                    
                    userDefault.synchronize()
                 
                    
            
                    
                    DispatchQueue.main.async { // Correct
                      // Dismiss keyboard
                      self.view.endEditing(true)
                        
                        // Present the home
                        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "home") {
                            UIApplication.shared.keyWindow?.rootViewController = viewController
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                    }
                   
                }
             //伺服器回傳的錯誤訊息
            } catch let error as NSError {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    Tool().alertMsg(viewController: self, alertTitle:"登入失敗" , alertMessage:"\(error.localizedDescription)" )
                }
            }
        })
        dataTask.resume()
    }
            
}


