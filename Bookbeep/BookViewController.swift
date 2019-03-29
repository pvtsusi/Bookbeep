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
import Toucan

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
        if book?.mock ?? false {
            takePhoto(self)
        }
    }
    
    // MARK: Actions
    
    @IBAction func saveBook(_ sender: Any) {
        let url = "\(Bookdump.API_ROOT)/create"
        let params = book!.toParams(overrideRecommended: recommendedSwitch.isOn)
        var jsonData: Data
        do {
            jsonData = try JSON(params).rawData()
        } catch let jsonError {
            fatalError(jsonError.localizedDescription)
        }
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        let coverJpeg = self.coverToSmallJpeg()
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = coverJpeg {
                multipartFormData.append(imageData, withName: "cover", fileName: "\(self.book!.isbn).jpg", mimeType: "image/jpeg")
            }
            multipartFormData.append(jsonData, withName: "metadata", mimeType: "application/json")
            }, to: url, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseSwiftyJSON { [weak self] response in
                        guard let strongSelf = self else {
                            return
                        }
                        if (response.response?.statusCode != 201) {
                            var errorMsg = "Could not read Bookdump response"
                            if let json = response.value {
                                if let error = json["error"].string {
                                    errorMsg = error;
                                }
                            }
                            let alert = UIAlertController(title: "Book addition failed", message: errorMsg,     preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
                            strongSelf.present(alert, animated: true, completion: nil)
                        } else {
                            let skippedBarcode = strongSelf.book?.mock ?? false
                            let origControllerIndex = skippedBarcode ? 0 : 1
                            if let targetViewController = strongSelf.navigationController?.viewControllers[origControllerIndex] {
                                strongSelf.navigationController?.popToViewController(targetViewController, animated: true)
                            }
                        }

                    }
                case .failure(let encodingError):
                    fatalError("error:\(encodingError)")
                }
        })
    }
    
    private func coverToSmallJpeg() -> Data? {
        guard let image = coverImageView.image else {
            return nil
        }
        let resizedImage = Toucan.Resize.resizeImage(image, size: CGSize(width: 540, height: 540), fitMode: .clip)
        return resizedImage?.jpegData(compressionQuality: 0.75)
    }
        
    @IBAction func takePhoto(_ sender: Any) {
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
