//
//  Item.swift
//  Todoey
//
//  Created by David Phillips on 3/14/19.
//  Copyright © 2019 dlp. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
	@objc dynamic var title: String = ""
	@objc dynamic var done: Bool = false
	var parentCategory = LinkingObjects (fromType: Category.self, property: "items")
}
