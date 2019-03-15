//
//  BookViewController.swift
//  Bookbeep
//
//  Created by Petteri Susi on 14/03/2019.
//  Copyright © 2019 Petteri Susi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

class BookViewController: UIViewController {

    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorLabel.text = book?.author
        titleLabel.text = book?.title
    }
    
    @IBAction func saveBook(_ sender: Any) {
        let url = "\(Bookdump.API_ROOT)/book"
        let params = book?.toParams()
        let enc = JSONEncoding.default
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: enc, headers: headers).responseSwiftyJSON { response in
            if (response.response?.statusCode != 201) {
                var errorMsg = "Could not read Bookdump response"
                if let json = response.value {
                    if let error = json["error"].string {
                        errorMsg = error;
                    }
                }
                let alert = UIAlertController(title: "Book addition failed", message: errorMsg,     preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
                self.present(alert, animated: true, completion: nil)
            } else {
                if let targetViewController = self.navigationController?.viewControllers[1] {
                    self.navigationController?.popToViewController(targetViewController, animated: true)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
