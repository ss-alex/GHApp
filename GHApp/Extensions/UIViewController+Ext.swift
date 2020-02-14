//
//  UIViewController+Ext.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/7.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController { // create this extansion to add GFAlertVC to all the ViewControllers in the APP
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    
    func showLoadingView () {
        containerView = UIView(frame: view.bounds) /// it fills the whole screen
        view.addSubview(containerView)
        
        containerView.backgroundColor   = .systemBackground
        containerView.alpha             = 0 /// alpha = transperency
        
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 } /// going from 0 transperency to 0.8 with animation
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        activityIndicator.startAnimating() /// it starts the animation of the progress indicator
    }
    
    
    func dismissLoadingView () { /// to dismiss the loading view when the loading is done
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    
    func showSafariView (for url: URL) {
        let safariVC                        = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor  = .systemGreen
        present(safariVC, animated: true)
    }
    
}

