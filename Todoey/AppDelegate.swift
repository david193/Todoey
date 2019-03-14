//
//  AppDelegate.swift
//  Todoey
//
//  Created by David Phillips on 3/12/19.
//  Copyright © 2019 dlp. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		// print (Realm.Configuration.defaultConfiguration.fileURL!)

		do {
			_ = try Realm()
		} catch {
			print ("app:didFinishLaunchingWithOptions: init Realm error: \(error)")
		}
		
		
		return true
	}
	
}

