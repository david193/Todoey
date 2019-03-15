//
//  Category.swift
//  Todoey
//
//  Created by David Phillips on 3/14/19.
//  Copyright © 2019 dlp. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var bgColor: String = ""
	let items = List<Item>()
}
