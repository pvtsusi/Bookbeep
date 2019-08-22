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
        
        let url = "\(Bookdump.apiBaseUrl())/test"
        
        Alamofire.request(url)
            .authenticate(user: Bookdump.apiUser(), password: Bookdump.apiPass())
            .responseJSON { response in
            if (response.response == nil) {
                print("No response")
            } else if (response.error != nil) {
                print("Response error: \(response.error)")
            } else if (response.response!.statusCode != 200) {
                print("Response status: \(response.response!.statusCode)")
            } else {
                print("OK!")
            }
        }
    }
}
