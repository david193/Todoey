//
//  TodoListViewController
//  Todoey
//
//  Created by David Phillips on 3/12/19.
//  Copyright © 2019 dlp. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

	var todoItems: Results<Item>?
	let realm = try! Realm()

	var selectedCategory: Category? {
		didSet {
			loadItems()
		}
	}


	override func viewDidLoad() {
		super.viewDidLoad()
//		let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//		print(dataFilePath)
	}


	// MARK: - Tableview Datasource Methods

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoItems?.count ?? 1
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		if let item = todoItems?[indexPath.row] {
			cell.textLabel?.text = item.title
			cell.accessoryType = item.done ? .checkmark : .none
		}
		else {
			cell.textLabel?.text = "No items yet"
		}
		return cell
	}


	// MARK: - TableView Delegate Methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		// print ("didSelectRowAt \(indexPath.row): \(itemArray[indexPath.row].title)")

//		todoItems?[indexPath.row].done = !todoItems?[indexPath.row].done
//		saveItems()
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
					if let currentCategory = self.selectedCategory {
						do {
							try self.realm.write {
								let item = Item()
								item.title = textField.text!
								currentCategory.items.append(item)
							}
						} catch {
							print ("Add item error saving new item: \(error)")
						}
					}  // if
					self.tableView.reloadData()
				}  // anonymous function
		

		alert.addTextField {
			(alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField  // textfield stays in scope long enough to get text field value
		}

		alert.addAction (action)
		present (alert, animated: true, completion: nil)
	}

	// MARK - Model Manipulation Methods

	func loadItems()  {
		todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
		tableView.reloadData()
	}

}  // class TodoListViewController


// MARK: Search bar methods

//extension TodoListViewController: UISearchBarDelegate {
//
//	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//		let request: NSFetchRequest<Item> = Item.fetchRequest()
//		request.predicate = NSPredicate (format: "title CONTAINS[cd] %@", searchBar.text!)
//		request.sortDescriptors = [NSSortDescriptor (key: "title", ascending: true)]
//
//		loadItems (with: request)
//	}
//
//	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//		if searchBar.text?.count == 0 {
//			loadItems()
//			DispatchQueue.main.async {
//				searchBar.resignFirstResponder()
//			}
//		}
//	}
//
//}  //  extension TodoListViewController: UISearchBarDelegate
