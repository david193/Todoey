//
//  CategoryViewController.swift
//  Todoey
//
//  Created by David Phillips on 3/13/19.
//  Copyright © 2019 dlp. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

	var categories = [Category]()
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
		loadCategories()
    }

	// MARK: - TableView Datasource Methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell (withIdentifier: "CategoryCell", for: indexPath)
		cell.textLabel?.text = categories[indexPath.row].name
		return cell
	}
	
	// MARK: - Data Manipulation Methods
	
	func loadCategories () {
		let request: NSFetchRequest<Category> = Category.fetchRequest()
		do {
			categories = try context.fetch (request)
		} catch {
			print ("loadCategories(): Error fetching categories: \(error)")
		}
		tableView.reloadData()
	}

	func saveCategories () -> Void {
		do {
			try context.save()
		} catch {
			print ("saveCategories(): error saving context: \(error)")
		}
		tableView.reloadData()
	}
	
	// MARK: - Add New Categories
	
	@IBAction func addButtonPressed (_ sender: UIBarButtonItem) {
		var categoryTextField = UITextField()
		let action = UIAlertAction (title: "Add category", style: .default) {
			(action) in
			let category = Category (context: self.context)
			category.name = categoryTextField.text!
			self.categories.append (category)
			self.saveCategories()
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
	
	
}
