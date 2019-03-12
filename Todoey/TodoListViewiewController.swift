//
//  ViewController.swift
//  Todoey
//
//  Created by David Phillips on 3/12/19.
//  Copyright © 2019 dlp. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

	let itemArray = ["Do #1", "Do #2", "Do #3"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	//MARK - Tableview Datasource Methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		cell.textLabel?.text = itemArray[indexPath.row]
		return cell
	}
	
	//MARK - TableView Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// print ("didSelectRowAt \(indexPath.row): \(itemArray[indexPath.row])")
		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		} else {
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}

}  // class TodoListViewController

