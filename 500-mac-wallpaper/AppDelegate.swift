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
    
    
    var timer: Timer?
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) {_ in
            self.updateWallpaper()
        }

    }

    func updateWallpaper() {
        print(1)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    deinit {
        timer?.invalidate()
    }


}

