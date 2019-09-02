//
//  ConfigTableViewCell.swift
//  Bookbeep
//
//  Created by Petteri Susi on 15/08/2019.
//  Copyright © 2019 Petteri Susi. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let configLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let check = UIImage(named: "check.pdf")
    let alert = UIImage(named: "alert.pdf")
    let glyphView = UIImageView(frame: CGRect.zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cellView)
        cellView.addSubview(configLabel)
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        configLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        configLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        configLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        configLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        
        glyphView.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(glyphView)
        glyphView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        glyphView.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -30).isActive = true
        
        settingsChanged()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func settingsChanged(notification: NSNotification) {
        if (notification.userInfo?["BookdumpUrl"] != nil) {
            Bookdump.shared.clearStatus()
            let newUrl = notification.userInfo!["BookdumpUrl"] as! String
            setLabel(newUrl)
            setConfigured(Bookdump.configured(url: newUrl))
        }
        if (notification.userInfo?["BookdumpUser"] != nil) {
            Bookdump.shared.clearStatus()
            setConfigured(Bookdump.configured(user: notification.userInfo!["BookdumpUser"] as? String))
        }
        if (notification.userInfo?["BookdumpPass"] != nil) {
            Bookdump.shared.clearStatus()
            setConfigured(Bookdump.configured(pass: notification.userInfo!["BookdumpPass"] as? String))
        }
        if (notification.userInfo?["TestSuccess"] != nil) {
            setConfigured(Bookdump.configured(testSuccess: notification.userInfo!["TestSuccess"] as? Bool))
        }
    }

    func settingsChanged() {
        if Bookdump.configured() {
            setLabel(Bookdump.apiBaseUrl())
            setConfigured(true)
        } else {
            setLabel(nil)
            setConfigured(false)
        }
    }
    
    func setConfigured(_ configured: Bool) {
        if (configured) {
            glyphView.image = check;
        } else {
            configLabel.text = "Set up the connection"
            glyphView.image = alert;
        }
    }
    
    func setLabel(_ newValue: String?) {
        if let value = newValue {
            if (!value.isEmpty) {
                configLabel.text = value
                return
            }
        }
    }
}
