//
//  PreferencesWindow.swift
//  500-mac-wallpaper
//
//  Created by Marek Kadlčík on 12/02/2017.
//  Copyright © 2017 Marek Kadlčík. All rights reserved.
//

import Cocoa

class PreferencesWindow: NSWindowController {
    
    override var windowNibName : String! {
        return "PreferencesWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
}
