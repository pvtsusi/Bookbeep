//
//  ViewController.swift
//  Bookbeep
//
//  Created by Petteri Susi on 09/03/2019.
//  Copyright © 2019 Petteri Susi. All rights reserved.
//

import UIKit
import BarcodeScanner
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

struct Bookdump {
    static let API_ROOT = "http://10.1.1.192:5000";
}

class ViewController: UIViewController {
    @IBOutlet var presentScannerButton: UIButton!
    @IBOutlet var pushScannerButton: UIButton!
    
    @IBAction func handleScannerPush(_ sender: Any, forEvent event: UIEvent) {
        let viewController = makeBarcodeScannerViewController()
        viewController.title = "Barcode Scanner"
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func makeBarcodeScannerViewController() -> BarcodeScannerViewController {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        return viewController
    }
}

// MARK: - BarcodeScannerCodeDelegate
extension ViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {

        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")

        let url = "\(Bookdump.API_ROOT)/api/search/\(code)"
        Alamofire.request(url).responseSwiftyJSON { response in
            if (response.response?.statusCode != 200) {
                controller.resetWithError();
            } else {
                controller.reset()
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let bookTableViewController = storyBoard.instantiateViewController(withIdentifier: "bookTableViewController") as! BookTableViewController
                if let booksJson = response.value {
                    for (_, bookJson): (String, JSON) in booksJson {
                        if let book = Book(isbn: code, title: bookJson["title"].stringValue, author: bookJson["author"].stringValue, language: bookJson["language"].stringValue) {
                            bookTableViewController.addCandidate(book)
                        }
                    }
                }
                controller.navigationController?.pushViewController(bookTableViewController, animated: true)
            }
        }
    }
}

// MARK: - BarcodeScannerErrorDelegate
extension ViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}

// MARK: - BarcodeScannerDismissalDelegate
extension ViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


