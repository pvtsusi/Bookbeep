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

struct Bookdump {
    static let API_ROOT = "http://10.1.1.196:5000";
}

class ViewController: UIViewController {
    @IBOutlet var presentScannerButton: UIButton!
    @IBOutlet var pushScannerButton: UIButton!
    
    @IBAction func handleScannerPresent(_ sender: Any, forEvent event: UIEvent) {
        let viewController = makeBarcodeScannerViewController()
        viewController.title = "Barcode Scanner"
        present(viewController, animated: true, completion: nil)
    }
    
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

        let url = "\(Bookdump.API_ROOT)/book"
        let params = [ "isbn": code ]
        let encoding = JSONEncoding.default
        Alamofire.request(url, method: .post, parameters: params, encoding: encoding).response { response in
            if (response.response?.statusCode != 201) {
                controller.resetWithError();
            } else {
                controller.reset(animated: true)
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


