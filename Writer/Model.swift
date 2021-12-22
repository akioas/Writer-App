import SwiftUI
import UIKit


var colorContinuous:Color? = .black //for continuous line button



//save image to share
extension UIView {
    func saveImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.layer.frame.size, false, 0.0)
        self.drawHierarchy(in: self.layer.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return img!

        
    }
}

extension View {
    func saveImage(size: CGSize) -> UIImage {

        let originPoint = CGPoint(x:0,y:0)

        let controller = UIHostingController(rootView: self)
        controller.view.bounds = CGRect(origin: originPoint, size: size)
        let image = controller.view.saveImage()
        return image
    }
}







let keyPoints = "PointsKey"
//var KeyForUserDefaults = keyPoints + String(loadNum(KeyForUserDefaults: keyCurrentViewNum))


func savePoints(_ points: [[CGPoint]]) {
    let KeyForUserDefaults = keyPoints + String(loadNum(KeyForUserDefaults: keyCurrentViewNum))
    let data = points.map { try? JSONEncoder().encode($0) }
    UserDefaults.standard.set(data, forKey: KeyForUserDefaults)

}


func loadPoints() -> [[CGPoint]] {
    let KeyForUserDefaults = keyPoints + String(loadNum(KeyForUserDefaults: keyCurrentViewNum))
    
    guard let encodedData = UserDefaults.standard.array(forKey: KeyForUserDefaults) as? [Data] else {
        return [[]]
    }
    
    
    var encodedReturn = encodedData.map { try! JSONDecoder().decode([CGPoint].self, from: $0) }
    currentLayer = encodedReturn.count - 1
    pathVar = Path()
    for currentNum in 0...currentLayer{
        guard let firstPoint = encodedReturn[currentNum].first else { return [[]]
            
        }
        
        pathVar.move(to: firstPoint)
        for pointIndex in 1..<encodedReturn[currentNum].count{
            
            pathVar.addLine(to: encodedReturn[currentNum][pointIndex])
            
        }

    }
    
    encodedReturn.append([])
    currentLayer = currentLayer + 1
    return encodedReturn
}



func loadPointsForPreview() -> [[[CGPoint]]] {
    var encodedReturn:[[[CGPoint]]] = [[[]]]
    let maxViewNum:Int = loadNum(KeyForUserDefaults: keyMaxViewNum)
    for num in 0..<maxViewNum{
    let KeyForUserDefaults = keyPoints + String(num)
    
    guard let encodedData = UserDefaults.standard.array(forKey: KeyForUserDefaults) as? [Data] else {
        return [[]]
    }
        encodedReturn.append(encodedData.map { try! JSONDecoder().decode([CGPoint].self, from: $0) })

    }
  
    if encodedReturn[0] == [[]]{
        encodedReturn.remove(at: 0)
    }
    
    return encodedReturn
}





let keyCurrentViewNum = "CurrentViewNumKey"
let keyMaxViewNum = "MaxViewNumKey"


func saveNum(_ num: Int, KeyForUserDefaults: String) {
    UserDefaults.standard.set(num, forKey: KeyForUserDefaults)
   
}




func loadNum(KeyForUserDefaults: String) -> Int {
    
    let encodedData = UserDefaults.standard.integer(forKey: KeyForUserDefaults)

    return encodedData
}




func deleteView(deletedViewNum: Int,  maxViewNum: Int)->([[CGPoint]]) {
    
    if deletedViewNum == maxViewNum - 1{
        let keyToDelete = keyPoints + String(deletedViewNum)
        UserDefaults.standard.removeObject(forKey: keyToDelete)
            
    }
    else {
        var keyToReassign = keyPoints
        for viewNum in deletedViewNum..<maxViewNum{
            let keyToDelete = keyPoints + String(viewNum)
            //
            keyToReassign = keyPoints + String(viewNum+1)
            guard let encodedData = UserDefaults.standard.array(forKey: keyToReassign) as? [Data] else {
                return [[]]
            }
            
            let encodedReturn = encodedData.map { try! JSONDecoder().decode([CGPoint].self, from: $0) }
            
            let data = encodedReturn.map { try? JSONEncoder().encode($0) }
            UserDefaults.standard.set(data as Any?, forKey: keyToDelete)
            print(keyToReassign)
            print(maxViewNum)
            //
        }
        print("!")
//        let keyToDelete = keyPoints + String(maxViewNum + 1)
        print("!")
        UserDefaults.standard.removeObject(forKey: keyToReassign)
//        UserDefaults.standard.removeObject(forKey: (keyToReassign+"1"))
        
        print(keyToReassign)
        
    }
    return [[]]
}




func addPoint(_ value: DragGesture.Value) -> CGPoint{
    var pointToAppend = value.location
    if (value.location.x < screenWidth)&&(value.location.y < screenWidth) {
    } else if (value.location.x > screenWidth)&&(value.location.y < screenWidth) {
        pointToAppend.x = screenWidth
    } else if (value.location.x < screenWidth)&&(value.location.y > screenWidth) {
        pointToAppend.y = screenWidth
    } else if (value.location.x > screenWidth)&&(value.location.y > screenWidth) {
        pointToAppend.x = screenWidth
        pointToAppend.y = screenWidth
    }
    
    if (value.location.y < 0){
        pointToAppend.y = 0
    }
    return pointToAppend
}
