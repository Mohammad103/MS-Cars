//
//  UIView+Utilities.swift
//  MS Cars
//
//  Created by Mohammad Shaker on 3/18/19.
//  Copyright © 2019 Mohammad Shaker. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

let loadingIndicatorViewTag = -9999

extension UIViewController {
    
    func showLoadingIndicator() {
        guard view.viewWithTag(loadingIndicatorViewTag) == nil else {
            return
        }
        let indicatorViewWidth: CGFloat = 50
        let indicatorViewHeight: CGFloat = 50
        
        let indicatorView: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: indicatorViewWidth, height: indicatorViewHeight), type: .circleStrokeSpin, color: UIColor.primaryColor, padding: nil)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: indicatorViewWidth * 2, height: indicatorViewHeight * 2))
        containerView.tag = loadingIndicatorViewTag
        containerView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        containerView.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        containerView.layer.cornerRadius = 15.0
        
        indicatorView.center = CGPoint(x: containerView.bounds.width / 2, y: containerView.bounds.height / 2)
        containerView.addSubview(indicatorView)
        
        view.addSubview(containerView)
        view.bringSubviewToFront(containerView)
        view.isUserInteractionEnabled = false
        indicatorView.startAnimating()
    }
    
    func hideLoadingIndicator() {
        if let indicatorView = view.viewWithTag(loadingIndicatorViewTag) {
            indicatorView.removeFromSuperview()
            view.isUserInteractionEnabled = true
        }
    }

}
