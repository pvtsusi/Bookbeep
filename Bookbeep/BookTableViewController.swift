//
//  BookTableViewController.swift
//  Bookbeep
//
//  Created by Petteri Susi on 12/03/2019.
//  Copyright © 2019 Petteri Susi. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {

    //MARK: Properties
    var candidates = [Book]()
    var selected: Book?
    
    public func addCandidate(_ candidate: Book) {
        candidates.append(candidate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndentifier = "BookTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? BookTableViewCell else {
            fatalError("The dequeued cell is not a BookTableViewCell")
        }
        let candidate = candidates[indexPath.row]
        cell.authorLabel.text = candidate.author
        cell.titleLabel.text = candidate.title
        cell.book = candidate

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let cell = sender as? BookTableViewCell else {
            return;
        }
        guard let bookViewController = segue.destination as? BookViewController else {
            return;
        }
        bookViewController.book = cell.book
    }

    // MARK: Private methods
    
    private func loadSampleBooks() {
        guard let book1 = Book(isbn: "9789510437193", title: "Title Here", author: "Author here") else {
            fatalError("Unable to init book1")
        }
        guard let book2 = Book(isbn: "0123456789012", title: "Another title", author: "Another Author here") else {
            fatalError("Unable to init book2")
        }
        candidates += [book1, book2]
    }
}
