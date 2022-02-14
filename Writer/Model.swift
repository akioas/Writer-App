import SwiftUI
import UIKit

var items:[[[CGPoint]]] = [[[]]]
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


let keyCurrentViewNum = "CurrentViewNumKey"
let keyMaxViewNum = "MaxViewNumKey"


func saveNum(_ num: Int, KeyForUserDefaults: String) {
    UserDefaults.standard.set(num, forKey: KeyForUserDefaults)
   
}




func loadNum(KeyForUserDefaults: String) -> Int {
    
    let encodedData = UserDefaults.standard.integer(forKey: KeyForUserDefaults)
    

    return encodedData
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
