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
import InAppSettingsKit

class ViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
//    @IBOutlet var pushScannerButton: UIBarButtonItem!
//    @IBOutlet weak var photoButton: UIBarButtonItem!
    
    @IBOutlet weak var pushScanerButton: UIBarButtonItem!
    @IBOutlet weak var photoButton: UIBarButtonItem!
    
    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(SettingsTableViewCell.self, forCellReuseIdentifier: "cellId")

        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.heightAnchor.constraint(equalToConstant: 110),
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])        
    }
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateConfiguredState), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateConfiguredState), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateConfiguredState), name: UserDefaults.didChangeNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settingsChanged(notification:)), name: NSNotification.Name(rawValue: kIASKAppSettingChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settingsChanged(notification:)), name: Notification.Name("TestConnectionStatus"), object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // my selector that was defined above
    @objc func updateConfiguredState() {
        if let cell = tableview.cellForRow(at: IndexPath(row: 0, section: 0)) {
            let configCell = cell as! SettingsTableViewCell
            configCell.settingsChanged()
        }
        setConfigured(Bookdump.configured(), cell: nil)
    }
    
    @objc func settingsChanged(notification: NSNotification) {
        let cell = tableview.cellForRow(at: IndexPath(row: 0, section: 0)) as? SettingsTableViewCell
        if (notification.userInfo?["BookdumpUrl"] != nil) {
            Bookdump.shared.clearStatus()
            let newUrl = notification.userInfo!["BookdumpUrl"] as! String
            cell?.setLabel(newUrl)
            setConfigured(Bookdump.configured(url: newUrl), cell: cell)
        }
        if (notification.userInfo?["BookdumpUser"] != nil) {
            Bookdump.shared.clearStatus()
            setConfigured(Bookdump.configured(user: notification.userInfo!["BookdumpUser"] as? String), cell: cell)
        }
        if (notification.userInfo?["BookdumpPass"] != nil) {
            Bookdump.shared.clearStatus()
            setConfigured(Bookdump.configured(pass: notification.userInfo!["BookdumpPass"] as? String), cell: cell)
        }
        if (notification.userInfo?["TestSuccess"] != nil) {
            setConfigured(Bookdump.configured(testSuccess: notification.userInfo!["TestSuccess"] as? Bool), cell: cell)
        }
    }
    
    private func setConfigured(_ configured: Bool, cell: SettingsTableViewCell?) {
        cell?.setConfigured(configured)
        pushScanerButton.isEnabled = configured
        photoButton.isEnabled = configured
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.autoresizingMask = .flexibleWidth
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 10, width: headerView.frame.width-10, height: headerView.frame.height - 20)
        label.text = "BOOKDUMP SERVER"
        label.font = label.font.withSize(12)
        label.textColor = .darkGray
        headerView.addSubview(label)
        
        let px = 1 / UIScreen.main.scale
        let line = UIView(frame: CGRect(x: 0, y: headerView.frame.height, width: tableView.frame.width, height: px))
        line.backgroundColor = tableView.separatorColor
        line.autoresizingMask = .flexibleWidth
        headerView.addSubview(line)
        NSLayoutConstraint.activate([line.widthAnchor.constraint(equalTo: headerView.widthAnchor)])

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SettingsTableViewCell
        cell.backgroundColor = UIColor.white
        cell.separatorInset.left = 0
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSettings", sender: tableView.cellForRow(at: indexPath))
    }
    
    @IBAction func handleScannerPush(_ sender: Any, forEvent event: UIEvent) {
        let viewController = makeBarcodeScannerViewController()
        viewController.title = "Barcode Scanner"
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func handleTakePhoto(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let bookViewController = storyBoard.instantiateViewController(withIdentifier: "bookViewController") as! BookViewController
        bookViewController.book = Book.mockBook()
        navigationController?.pushViewController(bookViewController, animated: false)
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

        let url = "\(Bookdump.normalizeApiBaseUrl())/search/\(code)"
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


