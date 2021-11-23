import SwiftUI
import UIKit

//var fileNum = 1//save

struct PreviewImage{
    func path(fileNum: Int)->(URL){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)


        
       
        let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        let fileName = String(fileNum)
        
        return path.appendingPathComponent(fileName).appendingPathExtension("jpg")
    
    
    }
    
    
    
    func savePreviewImage(fileNum: Int){

        let fileURL = path(fileNum: fileNum)
        print(fileURL)
        let image = FirstView().drawView.saveImage(size: imageSize).jpegData(
            compressionQuality: 1)

        do {
            let result = try! image?.write(to: fileURL, options: .atomic)
        } catch let error {
            print(error)
        }
    }


}





extension UIView {
    func saveImage() -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = false
        UIGraphicsBeginImageContextWithOptions(self.layer.frame.size, false, 1.0)
        self.drawHierarchy(in: self.layer.frame, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return img!
            //change bounds
        
    }
}

extension View {
    func saveImage(size: CGSize) -> UIImage {
        let yPoint = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        let originPoint = CGPoint(x: -10, y: -10 )
//        print(originPoint)
        let controller = UIHostingController(rootView: self)
        controller.view.bounds = CGRect(origin: originPoint, size: size)
        let image = controller.view.saveImage()
        return image
    }
}

/*
 let cropRect = mapVC.view.frame.inset(by: mapVC.view.safeAreaInsets).inset(by: mapVC.mapEdgeInsets)
 let mapRenderer = UIGraphicsImageRenderer(bounds: cropRect)
 let img = renderer.image(actions:  { _ in
     mapVC.view.drawHierarchy(in: mapVC.view.bounds, afterScreenUpdates: true)
 })
 */

/*
 let cropRect = mapVC.view.frame.inset(by: mapVC.view.safeAreaInsets).inset(by: mapVC.mapEdgeInsets)

 UIGraphicsBeginImageContextWithOptions(cropRect.size, false, 1.0)

 mapVC.view.drawHierarchy(in: mapVC.view.bounds afterScreenUpdates: true)
 let img = UIGraphicsGetImageFromCurrentImageContext()

 UIGraphicsEndImageContext()
 */











let keyPoints = "PointsKey"
var KeyForUserDefaults = keyPoints + String(loadViewNum(KeyForUserDefaults: keyCurrentViewNum))


func savePoints(_ points: [[CGPoint]]) {
    let KeyForUserDefaults = keyPoints + String(loadViewNum(KeyForUserDefaults: keyCurrentViewNum))
    let data = points.map { try? JSONEncoder().encode($0) }
    UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
//    savePreviewImage()
}




func loadPoints() -> [[CGPoint]] {
    let KeyForUserDefaults = keyPoints + String(loadViewNum(KeyForUserDefaults: keyCurrentViewNum))
    
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







//@State var currentViewNum = 0
//@State var maxViewNum = 0



let keyCurrentViewNum = "CurrentViewNumKey"
let keyMaxViewNum = "MaxViewNumKey"


func saveViewNum(_ num: Int, KeyForUserDefaults: String) {
//    let data = try! JSONEncoder().encode(num)
    UserDefaults.standard.set(num, forKey: KeyForUserDefaults)
    print("save")
}




func loadViewNum(KeyForUserDefaults: String) -> Int {
    
    let encodedData = UserDefaults.standard.integer(forKey: KeyForUserDefaults)
    
//    let encodedReturn = try! JSONDecoder().decode(Int.self, from: encodedData)
    print("load")
    print(KeyForUserDefaults)
    print(encodedData)
    return encodedData
}







