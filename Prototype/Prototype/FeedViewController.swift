//
//  FeedViewController.swift
//  Prototype
//
//  Created by Finn Ebeling on 25.02.24.
//

import UIKit

class FeedViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath)
    }
}
