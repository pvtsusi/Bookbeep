//
//  ConnectionStatusView.swift
//  Bookbeep
//
//  Created by Petteri Susi on 23/08/2019.
//  Copyright © 2019 Petteri Susi. All rights reserved.
//

import UIKit

class ConnectionStatusView : UIView {

    let spinner = UIActivityIndicatorView.init(style: .white)
    let label = UILabel(frame: CGRect.zero)
    
    init(width: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: 30))
        self.autoresizingMask = .flexibleWidth

        label.frame = CGRect(x: 0, y: 0, width: width, height: 30)
        label.textAlignment = .center
        label.text = ""
        self.addSubview(label)
        
        spinner.color = .black
        spinner.frame = self.frame
        spinner.center = self.center
    }
    
    func startSpinner() {
        if (spinner.superview == nil) {
            spinner.startAnimating()
            self.addSubview(spinner)
        }
        label.text = ""
    }
    
    func stopSpinner() {
        if (spinner.superview != nil) {
            spinner.stopAnimating()
            spinner.removeFromSuperview()
        }
    }
    
    @objc func setConnectionState(notification: Notification) {
        if let loading = notification.userInfo?["Loading"] as? Bool {
            if (loading) {
                startSpinner()
                return;
            }
        }
        stopSpinner()
        if let message = notification.userInfo?["Message"] as? String {
            label.text = message
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
