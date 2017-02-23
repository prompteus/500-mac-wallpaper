import Cocoa
import Foundation
import Alamofire


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    var timer: Timer?
    
    static let WALLPAPER_MIN_WIDTH = 1920
    static let WALLPAPER_MIN_HEIGHT = 1080
    static let WALLPAPER_MAX_RATIO_DIFFERENCE_FROM_SCREEN: Float = 0.15
    static let MAX_DOWNLOADED_PHOTOS = 5
    
    static let WALLPAPERS_URL = "https://api.500px.com/v1/photos?image_size=2048&feature=popular&only=Landscapes&consumer_key=" + AppDelegate.getApiKey()
    
    
    static var localWallpapersLocation: URL {
        get {
            var location = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)[0]
            location.appendPathComponent("500 Wallpapers", isDirectory: true)
            return location
        }
    }
        
    
    static func localWallpaperLocation(for filename: String) -> URL {
        var location = localWallpapersLocation
        location.appendPathComponent(filename, isDirectory: false)
        return location
    }
    
    static func localWallpaperDestination(for location: URL) -> DownloadRequest.DownloadFileDestination {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (location, [.createIntermediateDirectories])
        }
        return destination
    }
    
    static func getApiKey() -> String {
        if let apiKeyPlistPath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") {
            if let properties = NSDictionary(contentsOfFile: apiKeyPlistPath) as? [String: Any] {
                return properties["500pxApiKey"] as! String
            }
        }
        fatalError("ApiKeys.plist is missing")
    }
    
    static func isRatioOk(_ ratio: Float) -> Bool {
        let screenSize = NSScreen.main()!.frame.size
        let screenRatio = Float(screenSize.width / screenSize.height)
        return abs(screenRatio - ratio) <= WALLPAPER_MAX_RATIO_DIFFERENCE_FROM_SCREEN
    }
    
    static func cleanWallpapersDirectory() {
        let files = AppDelegate.listFilesFromOldestToNowest(atUrl: localWallpapersLocation)
        if (files.count) > MAX_DOWNLOADED_PHOTOS {
            let numberOfOldWallpapesToDelete = (files.count) - MAX_DOWNLOADED_PHOTOS
            
            let manager = FileManager.default
            for i in 0 ..< numberOfOldWallpapesToDelete {
                let oldestWallpaperFilename = files[i]
                try? manager.removeItem(at: localWallpaperLocation(for: oldestWallpaperFilename))
            }
        }
    }

    static func listFilesFromOldestToNowest(atUrl url: URL) -> [String] {
        
        let files = try? FileManager.default.contentsOfDirectory(at: url,
                                                includingPropertiesForKeys : [URLResourceKey.contentModificationDateKey],
                                                options: [.skipsHiddenFiles] )
        
        return (files?
            .sorted { ( u1: URL, u2: URL) -> Bool in
                let file1 = try? u1.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey])
                let file2 = try? u2.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey])
                if let date1 = file1?.contentModificationDate, let date2 = file2?.contentModificationDate {
                    return date1 < date2
                } else {
                    return true
                }
            }
            .map { $0.lastPathComponent })!
        
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) {_ in
            self.downloadNewWallpapers()
        }
    }
    
    func downloadNewWallpapers() {
        Alamofire.request(AppDelegate.WALLPAPERS_URL).validate().responseJSON { response in
            if response.result.isSuccess {
                let wallpapersUrls = self.arrayOfWallpapersURLs(from: response.result.value as! NSDictionary).shuffle().prefix(AppDelegate.MAX_DOWNLOADED_PHOTOS)
                for wallpaperUrl in wallpapersUrls {
                    let wallpaperFilename = (wallpaperUrl as NSString).lastPathComponent
                    let wallpaperDownloadLocation = AppDelegate.localWallpaperLocation(for: wallpaperFilename)
                    if (!FileManager.default.fileExists(atPath: wallpaperDownloadLocation.path)) {
                        let wallpaperDownloadDestination = AppDelegate.localWallpaperDestination(for: wallpaperDownloadLocation)
                        Alamofire.download(wallpaperUrl, to: wallpaperDownloadDestination).response { _ in AppDelegate.cleanWallpapersDirectory() }
                    }
                }
            }
        }
    }
    
    func arrayOfWallpapersURLs(from fullJsonResponse: NSDictionary) -> Array<String> {
        var array = Array<String>()
        for wallpaper in fullJsonResponse["photos"] as! [Dictionary<String, Any>] {
            let width = wallpaper["width"] as! Int
            let height = wallpaper["height"] as! Int
            let ratio = Float(width) / Float(height)
            if (width >= AppDelegate.WALLPAPER_MIN_WIDTH
                && height >= AppDelegate.WALLPAPER_MIN_HEIGHT
                && AppDelegate.isRatioOk(ratio)) {
                let wallpaperUrl = wallpaper["image_url"] as! String
                array.append(wallpaperUrl)
            }
        }
        return array
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    deinit {
        timer?.invalidate()
    }


}

