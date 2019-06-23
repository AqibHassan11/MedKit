//
//  ViewController.swift
//  MedKit
//
//  Created by Sium_MBSTU on 19/6/19.
//  Copyright © 2019 MedKit. All rights reserved.
//

import UIKit
import AccountKit

class ViewController: UIViewController {
    @IBOutlet weak var accessTokenLabel: UILabel!
    
    var accountKit: AccountKit?
    var authorizationCode: String?
    var pendingVC: AKFViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.accountKit = AccountKit.init(responseType: .accessToken)
        
        self.pendingVC = accountKit?.viewControllerForLoginResume()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if pendingVC != nil {
            self._prepareLoginViewController(loginViewController: pendingVC!)
            self.present(pendingVC as! UIViewController, animated: true, completion: nil)
        }
    }
    @IBAction func email(_ sender: Any) {
        //let vcEmail : AKFViewController = (accountKit?.viewControllerForEmailLogin(with: nil, state: nil))!
        //self._prepareLoginViewController(loginViewController: vcEmail)
        //self.present(vcEmail as! UIViewController, animated: true, completion: nil)
        accountKit?.requestAccount({ (account, error) in
            if let phoneNumber = account?.phoneNumber {
                self.accessTokenLabel.text = "\(phoneNumber.stringRepresentation())"
            }
        })
    }
    
    @IBAction func phone(_ sender: Any) {
        let vcPhone : AKFViewController = (accountKit?.viewControllerForPhoneLogin(with: nil, state: nil))!
        self._prepareLoginViewController(loginViewController: vcPhone)
        self.present(vcPhone as! UIViewController, animated: true, completion: nil)
    }
}

extension ViewController: AKFViewControllerDelegate{
    func _prepareLoginViewController(loginViewController: AKFViewController){
        loginViewController.delegate = self;
        loginViewController.uiManager = SkinManager.init(skinType: .classic, primaryColor: UIColor.cyan)
        
    }
    
    func viewController(_ viewController: UIViewController & AKFViewController, didFailWithError error: Error) {
        print(error)
    }
    
    func viewController(_ viewController: UIViewController & AKFViewController, didCompleteLoginWith accessToken: AccessToken, state: String) {
        self.accessTokenLabel.text = "Token String = \(accessToken.tokenString) \n Account Id = \(accessToken.accountID)"
    }
}

