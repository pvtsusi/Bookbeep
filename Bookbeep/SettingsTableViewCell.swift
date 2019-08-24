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
        if Bookdump.configured() {
            label.text = "Connected"
        } else {
            label.text = "Configure"
        }
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func settingsChanged(notification: NSNotification) {
        let newUrl = notification.userInfo?["bookdump_url"] as? String
        setLabel(newUrl)
    }
    
    func setLabel(_ newValue: String?) {
        if let value = newValue {
            if (!value.isEmpty) {
                configLabel.text = value
                return
            }
        }
        configLabel.text = "Configure"
    }
}
