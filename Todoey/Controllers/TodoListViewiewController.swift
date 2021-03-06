//
//  TodoListViewController
//  Todoey
//
//  Created by David Phillips on 3/12/19.
//  Copyright © 2019 dlp. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

	var todoItems: Results<Item>?
	let realm = try! Realm()

	var selectedCategory: Category? {
		didSet {
			loadItems()
		}
	}


	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.separatorStyle = .none
//		let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//		print(dataFilePath)
	}


	// MARK: - Tableview Datasource Methods

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoItems?.count ?? 1
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = super.tableView (tableView, cellForRowAt: indexPath)
		if let todoItem = todoItems?[indexPath.row] {
			cell.textLabel?.text = todoItem.title
//			let catColor = UIColor (hexString: (selectedCategory!.bgColor))
//			if let color = catColor.darken(byPercentage: CGFloat (indexPath.row) / CGFloat (todoItems!.count))
			if let color = UIColor (hexString: selectedCategory!.bgColor)?.darken (byPercentage: CGFloat (indexPath.row) / CGFloat (todoItems!.count))
			{
				cell.backgroundColor = color
				cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
			}
			cell.accessoryType = todoItem.done ? .checkmark : .none
		}
		else {
			cell.textLabel?.text = "No items yet"
		}
		return cell
		
//		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
//		if let item = todoItems?[indexPath.row] {
//			cell.textLabel?.text = item.title
//			cell.accessoryType = item.done ? .checkmark : .none
//		}
//		else {
//			cell.textLabel?.text = "No items yet"
//		}
//		return cell
	}


	// MARK: - TableView Delegate Methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		// print ("didSelectRowAt \(indexPath.row): \(itemArray[indexPath.row].title)")

		if let item = todoItems?[indexPath.row] {
			do {
				try realm.write {
					item.done = !item.done
				}
			} catch {
				print ("Error saving item.done status: \(error)")
			}
		}
		tableView.reloadData()
		
		tableView.deselectRow(at: indexPath, animated: true)
	}

	
	// MARK: - Delete data from Swipe

	override func deleteFromModel (at indexPath: IndexPath) {
		if let todoItem = todoItems?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete (todoItem)
				}
			} catch {
				print ("Error deleting item: \(error)")
			} // catch
		} // if
	}  // func updateModel
	

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
								item.dateCreated = Date()
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

extension TodoListViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
		tableView.reloadData()
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
