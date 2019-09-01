//
//  SettingsTableViewController.swift
//  Bookbeep
//
//  Created by Petteri Susi on 20/08/2019.
//  Copyright © 2019 Petteri Susi. All rights reserved.
//

import InAppSettingsKit
import Alamofire

class SettingsTableViewController : IASKAppSettingsViewController, IASKSettingsDelegate {
    
    func settingsViewControllerDidEnd(_ sender: IASKAppSettingsViewController!) {
    }
    
    override func viewDidLoad() {
        self.delegate = self
    }    

    func settingsViewController(_ sender: IASKAppSettingsViewController!, buttonTappedFor specifier: IASKSpecifier!) {
        if (specifier.key() != "BookdumpButton") {
            return
        }
        Bookdump.shared.testConnection()
    }
    
    func settingsViewController(_ settingsViewController: IASKViewController!, tableView: UITableView!, heightForHeaderForSection section: Int) -> CGFloat {
        if (settingsViewController.settingsReader.key(forSection: section) == "IASKCustomHeaderStyle") {
            return 30.0
        }
        return 0
    }
    
    func settingsViewController(_ settingsViewController: IASKViewController!, tableView: UITableView!, viewForHeaderForSection section: Int) -> UIView! {
        if (settingsViewController.settingsReader.key(forSection: section) == "IASKCustomHeaderStyle") {
            let view = ConnectionStatusView.init(width: tableView.frame.width)
            NotificationCenter.default.addObserver(view, selector: #selector(view.setConnectionState(notification:)), name: Notification.Name("TestConnectionStatus"), object: nil)
            return view
        }
        return nil
    }
}
