//
//  TodoListViewController
//  Todoey
//
//  Created by David Phillips on 3/12/19.
//  Copyright © 2019 dlp. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

	var itemArray = [Item]()

	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


	override func viewDidLoad() {
		super.viewDidLoad()
//		let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		// print(dataFilePath)
		loadItems ()
	}


	// MARK: - Tableview Datasource Methods

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


	// MARK: - TableView Delegate Methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		// print ("didSelectRowAt \(indexPath.row): \(itemArray[indexPath.row].title)")

		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		saveItems()
		tableView.deselectRow(at: indexPath, animated: true)
	}


	// MARK: - Add New Items

	@IBAction func addButtonPressed (_ sender: UIBarButtonItem) {
		var textField = UITextField()

		let alert = UIAlertController (title: "Add New Item",
									   message: "",
									   preferredStyle: .alert)

		let action = UIAlertAction (title: "Add Item",
									style: .default)
				{
					(action) in
					let item = Item (context: self.context)
					item.title = textField.text!
					item.done = false
					self.itemArray.append (item)
					self.saveItems()
				}

		alert.addTextField {
			(alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField  // textfield stays in scope long enough to get text field value
		}

		alert.addAction (action)
		present (alert, animated: true, completion: nil)
	}

	// MARK - Model Manipulation Methods
	func saveItems () {
		do {
			try context.save()
		} catch {
			print ("Error saving context: \(error)")
		}
		self.tableView.reloadData()

	}

	func loadItems (with request: NSFetchRequest<Item> = Item.fetchRequest())  {
		do {
			itemArray = try context.fetch(request)
		} catch {
			print ("Error fetching data: \(error)")
		}

		tableView.reloadData()
	}

}  // class TodoListViewController


// MARK: Search bar methods

extension TodoListViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		request.predicate = NSPredicate (format: "title CONTAINS[cd] %@", searchBar.text!)
		request.sortDescriptors = [NSSortDescriptor (key: "title", ascending: true)]

		loadItems (with: request)
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			loadItems()
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
		}
	}

}  //  extension TodoListViewController: UISearchBarDelegate
