//
//  SearchVC.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/3.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    let logoImageView           = UIImageView()
    let usernameTextField       = GFTextField()
    let callToActionButton      = GFButton(backgroundColor: .systemGreen, tittle: "Get Followers")
    
    var isUsernameEntered: Bool { return !usernameTextField.text!.isEmpty } // text validation
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) { //not to show the NavBar when SearchVC appear
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    func createDismissKeyboardGesture(){ //to dismiss the Keyboard when we type the text in a textField
        let tap = UITapGestureRecognizer(target: view.self, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    
    @objc func pushFollowerListVC() {  //this func will be called after action button is tapped
        
        guard isUsernameEntered else { //check if there is a text in the textField
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for.", buttonTitle: "Ok")
            return
        }
        view.endEditing(true) /// to dismiss the keyboard, and it is the same as 'usernameTextField.resignFirstResponder()''
        
        let followerListVC      = FollowerListVC(username: usernameTextField.text!)
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        let topConstraintConstant:CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80 /// if 'isiPhoneSE'- 20, if 'isiPhone8Zoomed' - 80
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant), ///to locate the keyboard properly
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    func configureTextField() {
        view.addSubview(usernameTextField)
        usernameTextField.delegate = self //connect the pushed return key and _delegate extension 
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureCallToActionButton () {
        view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}


extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // when return is pressed
        pushFollowerListVC()
        return true
    }
}
