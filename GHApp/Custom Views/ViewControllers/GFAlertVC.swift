//
//  GFAlertVC.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/7.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class GFAlertVC: UIViewController {

    let containerView       = GFAlertContainerView()
    let titleLabel          = GFTittleLabel(textAlignment: .center, fontSize: 20)
    let errorMessageLabel   = GFBodyLabel(textAlignment: .center)
    let actionButton        = GFButton(backgroundColor: .systemPink, tittle: "Ok")
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat    = 20 // in order not to write 20 every time
    
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle     = title
        self.message        = message
        self.buttonTitle    = buttonTitle
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75) /// = view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureErrorMessageLabel()
    }
    
    
    func configureContainerView() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 260),
            containerView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong" // if not - then text
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    
    func configureActionButton() {  //configuring the button at 2nd - body will fill all free space
        containerView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
    
    
    func configureErrorMessageLabel() {
        containerView.addSubview(errorMessageLabel)
        errorMessageLabel.text          = message ?? "Unable to complete request"
        errorMessageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            errorMessageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            errorMessageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            errorMessageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
        
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
        
    }
}
