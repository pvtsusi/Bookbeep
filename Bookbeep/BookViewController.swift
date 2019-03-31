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
        let url = "\(Bookdump.API_ROOT)/book"
        var params = book!.toParams(overrideRecommended: recommendedSwitch.isOn)
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        let resizedCover = self.coverToSmallJpeg()
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let cover = resizedCover {
                multipartFormData.append(cover.imageData, withName: "cover", fileName: "\(self.book!.isbn).jpg", mimeType: "image/jpeg")
                params["width"] = cover.width
                params["height"] = cover.height
            }
            let jsonData = self.paramsToJson(params: params)
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
    
    private func paramsToJson(params: Parameters) -> Data {
        do {
            return try JSON(params).rawData()
        } catch let jsonError {
            fatalError(jsonError.localizedDescription)
        }
    }
    
    struct ResizedCover {
        var imageData: Data
        var width: CGFloat
        var height: CGFloat
    }
    
    private func coverToSmallJpeg() -> ResizedCover? {
        guard let image = coverImageView.image else {
            return nil
        }
        guard let resizedImage = Toucan.Resize.resizeImage(image, size: CGSize(width: 540, height: 540), fitMode: .clip) else {
            return nil
        }
        let width = resizedImage.size.width * resizedImage.scale;
        let height = resizedImage.size.height * resizedImage.scale;
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.75) else {
            return nil
        }
        
        return ResizedCover(imageData: imageData, width: width, height: height)
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
