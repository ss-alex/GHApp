//
//  GFDataLoadingVC.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/2/27.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class GFDataLoadingVC: UIViewController {

    
    var containerView: UIView!

    func showLoadingView () {
        containerView = UIView(frame: view.bounds) /// it fills the whole screen
        containerView.backgroundColor   = .systemBackground
        containerView.alpha             = 0 /// alpha = transperency
        view.addSubview(containerView)
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 } /// going from 0 transperency to 0.8 with animation
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating() /// it starts the animation of the progress indicator
    }
    
    
    func dismissLoadingView () { /// to dismiss the loading view when the loading is done
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
