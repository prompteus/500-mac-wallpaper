import Foundation

extension Array {
    
    func chooseRandomElement() -> Element {
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return self[randomIndex]
    }
    
}
