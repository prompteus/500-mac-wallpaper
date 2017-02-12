import Cocoa

class StatusMenuController: NSObject {
    
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    
    override func awakeFromNib() {
        let icon = #imageLiteral(resourceName: "StatusIcon")
        icon.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    
    
}
