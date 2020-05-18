//
//  TableViewController.swift
//  HMTextView_Example
//
//  Created by gokhan on 18.05.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    // MARK: - Parameters
    private let links: [String] = ["@Gokhan", "#1", "@Çağrı", "#lotr", "#12:12", "@12Ali"]
    private var clickedItem: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = links[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedItem = links[indexPath.row]
        self.performSegue(withIdentifier: "segueViewer", sender: self)
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController {
            if let link = clickedItem {
                if link.count > 1 {
                    if link.contains("#") {
                        destination.predefinedType = .hashtag
                    } else {
                        destination.predefinedType = .mention
                    }
                    let rawLink = String(link.dropFirst())
                    destination.predefinedLink = rawLink
                }
            }
        }
    }

}
