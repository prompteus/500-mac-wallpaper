//
//  AppDelegate.swift
//  500-mac-wallpaper
//
//  Created by Marek Kadlčík on 11/02/2017.
//  Copyright © 2017 Marek Kadlčík. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)

    func buttonClicked() {
        print("Noot noot")
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let statusIcon = #imageLiteral(resourceName: "StatusIcon")
        statusIcon.isTemplate = true
        statusItem.image = statusIcon
        statusItem.button!.action = #selector(buttonClicked)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

