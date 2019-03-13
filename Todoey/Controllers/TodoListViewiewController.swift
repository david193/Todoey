//
//  ViewController.swift
//  Todoey
//
//  Created by David Phillips on 3/12/19.
//  Copyright © 2019 dlp. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

	var itemArray = [Item]()
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// print(dataFilePath!)

		loadItems()
	}

	
	//MARK - Tableview Datasource Methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		let item = itemArray[indexPath.row]
		cell.textLabel?.text = item.title
		cell.accessoryType = item.done ? .checkmark : .none

		return cell
	}
	
	
	//MARK - TableView Delegate Methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		// print ("didSelectRowAt \(indexPath.row): \(itemArray[indexPath.row].title)")
		
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		saveItems()
		tableView.deselectRow(at: indexPath, animated: true)
	}

	
	//MARK - Add New Items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		var textField = UITextField()
		
		let alert = UIAlertController (title: "Add New Item",
									   message: "",
									   preferredStyle: .alert)
		
		let action = UIAlertAction (title: "Add Item",
									style: .default)
				{
					(action) in
					// what will happen once the user clicks the Add Item button
					let item = Item()
					item.title = textField.text!

					self.itemArray.append (item)
					self.saveItems()
				}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField  // textfield stays in scope long enough to get text field value
		}
		
		alert.addAction(action)
		present (alert, animated: true, completion: nil)
	}
	
	//MARK - Model Manipulation Methods
	func saveItems () {
		let encoder = PropertyListEncoder()
		do {
			let data = try encoder.encode (self.itemArray)
			try data.write (to: self.dataFilePath!)
		} catch {
			print("Error encoding, \(error)")
		}
		self.tableView.reloadData()

	}
	
	func loadItems() {
		if let data = try? Data (contentsOf: dataFilePath!) {
			let decoder = PropertyListDecoder()
			do {
				itemArray = try decoder.decode([Item].self, from: data)
			} catch {
				print ("Error decoding item, \(error)")
			}
		}
	}
	
}  // class TodoListViewController

