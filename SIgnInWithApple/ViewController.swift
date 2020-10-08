//
//  ViewController.swift
//  SIgnInWithApple
//
//  Created by Muhammat Rasid Ridho on 14/08/20.
//  Copyright © 2020 Muhammat Rasid Ridho. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    @IBOutlet weak var AppleIDLabel : UILabel!
    @IBOutlet weak var firstNameLabel : UILabel!
    @IBOutlet weak var lastNameLabel : UILabel!
    @IBOutlet weak var emailIdLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAppleSignBtn()

    }
    
    func setUpAppleSignBtn() {
        let signInBtn = ASAuthorizationAppleIDButton()
        signInBtn.frame = CGRect (x: 20, y: (UIScreen.main.bounds.size.height - 170), width: (UIScreen.main.bounds.size.width - 40), height: 50)
        signInBtn.addTarget(self, action: #selector(signInActionBtn), for: .touchUpInside)
        
        self.view.addSubview(signInBtn)
    }
    
    @objc func signInActionBtn() {
        //    print ("Apple Sign In")
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
}


extension ViewController : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let alert = UIAlertController (title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            
            print(credentials.user)
            print(credentials.email!)
            print(credentials.fullName!)
            
            self.emailIdLabel.text = credentials.email
            self.firstNameLabel.text = credentials.fullName?.givenName
            self.lastNameLabel.text = credentials.fullName?.familyName
            self.AppleIDLabel.text = credentials.user
            
        
        case let credentials as ASPasswordCredential:
            print(credentials.password)
            
        default:
            let alert = UIAlertController (title: "Apple Sign In", message: "Something wrong with your Apple Sign In", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }
    }
    
}

extension ViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return view.window!
    }
    
}
