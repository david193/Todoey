//
//  CategoryViewController.swift
//  Todoey
//
//  Created by David Phillips on 3/13/19.
//  Copyright © 2019 dlp. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: SwipeTableViewController {

	let realm = try! Realm()
	
	var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
		loadCategories()
    }

	// MARK: - TableView Datasource Methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories?.count ?? 1  // ?? is the nill coallescing operator
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories yet"
		return cell
	}
	
	
	// MARK: - Data Manipulation Methods
	
	func loadCategories () {
		categories = realm.objects(Category.self)
		tableView.reloadData()
	}

	func save (category: Category) -> Void {
		do {
			try realm.write {
				realm.add (category)
			}
		} catch {
			print ("saveCategories(): error saving context: \(error)")
		}
		tableView.reloadData()
	}
	
	// MARK: - Delete data from Swipe
	
	override func deleteFromModel (at indexPath: IndexPath) {
		if let categoryForDeletion = self.categories?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete (categoryForDeletion)
				}
			} catch {
				print ("Error deleting category: \(error)")
			}
		}  // if

	}
	
	// MARK: - Add New Categories
	
	@IBAction func addButtonPressed (_ sender: UIBarButtonItem) {
		var categoryTextField = UITextField()
		let action = UIAlertAction (title: "Add category", style: .default) {
			(action) in
			let category = Category()
			category.name = categoryTextField.text!
			self.save (category: category)
		}
		
		let alert = UIAlertController (title: "Add new category", message: "", preferredStyle: .alert)
		alert.addTextField {
			(alertTextField) in
			alertTextField.placeholder = "Category name"
			categoryTextField = alertTextField  // catgoryTextField here captures the value of alertTextField before alertTextField can go out of scope.
		}
		alert.addAction (action)
		
		present(alert, animated: true, completion: nil)
	}
	
	// MARK: - TableView Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToItems", sender: self)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! TodoListViewController

		if let indexPath = tableView.indexPathForSelectedRow {
			destinationVC.selectedCategory = categories?[indexPath.row]
		}
	}
	
}
