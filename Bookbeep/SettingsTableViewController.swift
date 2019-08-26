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

        if (specifier.key() != "bookdump_button") {
            return
        }
        
        postStatus(loading: true)
        
        let url = "\(Bookdump.normalizeApiBaseUrl())/test"
        
        Alamofire.request(url)
            .authenticate(user: Bookdump.apiUser(), password: Bookdump.apiPass())
            .responseJSON { response in
            if (response.response == nil) {
                self.postStatus(loading: false, message: "No response from server")
            } else if (response.error != nil) {
                if (response.response!.statusCode == 401) {
                    self.postStatus(loading: false, message: "Bad username or password")
                } else {
                    self.postStatus(loading: false, message: "Connection failed")
                }
            } else if (response.response!.statusCode != 200) {
                self.postStatus(loading: false, message: "Server responded with an error")
            } else {
                self.postStatus(loading: false, message: "Connection OK!")
            }
        }
    }

    private func postStatus(loading: Bool, message: String? = nil) {
        var userInfo: [AnyHashable: Any] = ["Loading": loading]
        if (message != nil) {
            userInfo["Message"] = message
        }
        NotificationCenter.default.post(name: Notification.Name("TestConnectionStatus"), object: nil, userInfo: userInfo)
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
