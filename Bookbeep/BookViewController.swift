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

class BookViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var recommendedSwitch: UISwitch!
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorLabel.text = book?.author
        titleLabel.text = book?.title
        recommendedSwitch.isOn = book?.recommended ?? false
    }
    
    // MARK: Actions
    
    @IBAction func saveBook(_ sender: Any) {
        let url = "\(Bookdump.API_ROOT)/book"
        let params = book?.toParams(overrideRecommended: recommendedSwitch.isOn)
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
    
    @IBAction func takePhoto(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        coverImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
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
