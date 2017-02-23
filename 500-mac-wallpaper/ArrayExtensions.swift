import Foundation

extension Array {
    
    func chooseRandomElement() -> Element {
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return self[randomIndex]
    }

    func shuffle() -> Array {
        let c = count
        guard c > 1 else { return self }
        
        var newArray = self
        for _ in 0...6 {
            newArray = sorted { (_, _) in arc4random() < arc4random() }
        }
        return newArray
    }
    
}
