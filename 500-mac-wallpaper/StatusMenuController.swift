import Cocoa

class StatusMenuController: NSObject {
    
    
    @IBOutlet weak var statusMenu: NSMenu!
    var preferenceWindow: PreferencesWindow?
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        let icon = #imageLiteral(resourceName: "StatusIcon")
        icon.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    @IBAction func preferencesClicked(sender: NSMenuItem) {
        preferenceWindow = PreferencesWindow()
        preferenceWindow!.showWindow(nil)
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    
    
}
