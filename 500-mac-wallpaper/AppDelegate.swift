import Cocoa
import Alamofire


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    var timer: Timer?
    
    static let WALLPAPER_MIN_WIDTH = 1920
    static let WALLPAPER_MIN_HEIGHT = 1080
    
    static func getApiKey() -> String {
        if let apiKeyPlistPath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") {
            if let properties = NSDictionary(contentsOfFile: apiKeyPlistPath) as? [String: Any] {
                return properties["500pxApiKey"] as! String
            }
        }
        fatalError("ApiKeys.plist is missing")
    }
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) {_ in
            self.downloadNewWallpapers()
        }

    }

    func downloadNewWallpapers() {
        let featuredPhotosUrl = "https://api.500px.com/v1/photos?image_size=2048&only=Landscapes&consumer_key=" + AppDelegate.getApiKey()
        Alamofire.request(featuredPhotosUrl).validate().responseJSON { response in
            switch response.result {
            case .success:
                let wallpapersUrls = self.arrayOfWallpapersURLs(from: response.result.value as! NSDictionary)
                let randomWallpaperUrl = wallpapersUrls.chooseRandomElement()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func arrayOfWallpapersURLs(from fullJsonResponse: NSDictionary) -> Array<String> {
        var array = Array<String>()
        for wallpaper in fullJsonResponse["photos"] as! [Dictionary<String, Any>] {
            let width = wallpaper["width"] as! Int
            let height = wallpaper["height"] as! Int
            if (width >= AppDelegate.WALLPAPER_MIN_WIDTH && height >= AppDelegate.WALLPAPER_MIN_HEIGHT) {
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

