//
//  Tool.swift
//  註冊帳號
//
//  Created by 褚宣德 on 2017/9/28.
//  Copyright © 2017年 褚宣德. All rights reserved.
//

import UIKit


class Tool {
    

    
    // Functions
    
    func goToPage(withIdentifier id: String, currentViewController currentVC: UIViewController) {
        DispatchQueue.main.async {
            let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id)
            currentVC.present(viewController, animated: true, completion: nil)
        }
    }
    
    func alertMsg(viewController vc: UIViewController, alertTitle title: String, alertMessage msg: String){
        let myAlert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        myAlert.addAction(okAction)
        vc.present(myAlert, animated: true, completion: nil)
    }
    
    
    
    

    
    
    
}

