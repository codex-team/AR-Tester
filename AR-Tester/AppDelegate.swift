//
//  AppDelegate.swift
//  AR-Tester
//
//  Created by Peter Savchenko on 28/08/2017.
//  Copyright © 2017 Peter Savchenko. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

		func application(_ application: UIApplication,
		                 didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      Fabric.with([Crashlytics.self])
			return true
		}
}
