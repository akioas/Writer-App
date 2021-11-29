import SwiftUI
import UIKit



struct PreviewImage{
    func path(fileNum: Int)->(URL){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)


        var fileNumVar = loadNum(KeyForUserDefaults: "fileNumVar")
        print(fileNumVar)
       
        let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        let fileName = String(fileNum) + String("f") + String(fileNumVar)
        
        changeNum()
        let pathReturn = path.appendingPathComponent(fileName).appendingPathExtension("jpg")
//        saveURL(pathReturn)
        
        return pathReturn
    
    
    }
    
    func changeNum(){
        var fileNumVar = loadNum(KeyForUserDefaults: "fileNumVar")
        fileNumVar = fileNumVar + 1
        if fileNumVar > 0 {
            fileNumVar = 0
        } else {
            fileNumVar = 1
        }
        saveNum(fileNumVar, KeyForUserDefaults: "fileNumVar")
    }
    
    
    func savePreviewImage(fileNum: Int){

        let fileURL = path(fileNum: fileNum)
        let urlString = String(describing:fileURL)
        print(fileURL)
        var newURL: String
        var fileNumVar = loadNum(KeyForUserDefaults: "fileNumVar")
        if fileNumVar > 0 {
            newURL = urlString.replacingOccurrences(of: "f1", with: "f0")
        } else {
            newURL = urlString.replacingOccurrences(of: "f0", with: "f1")
        }
        
        
        
        let image = FirstView().drawView.saveImage(size: imageSize).jpegData(
            compressionQuality: 1)

        do {
            let result = try! image?.write(to: fileURL, options: .atomic)
            try! image?.write(to: URL(string:newURL)!, options: .atomic)
        } catch let error {
            print(error)
        }
    }


}





extension UIView {
    func saveImage() -> UIImage {
//        let format = UIGraphicsImageRendererFormat()
//        format.scale = 1
//        format.opaque = false
        UIGraphicsBeginImageContextWithOptions(self.layer.frame.size, false, 0.0)
        self.drawHierarchy(in: self.layer.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return img!

        
    }
}

extension View {
    func saveImage(size: CGSize) -> UIImage {
//        let yPoint = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
//        let originPoint = CGPoint(x: -10, y: -10 )
        let originPoint = CGPoint(x:0,y:0)

//        print(originPoint)
        let controller = UIHostingController(rootView: self)
        controller.view.bounds = CGRect(origin: originPoint, size: size)
        let image = controller.view.saveImage()
        return image
    }
}
/*
 return UIGraphicsImageRenderer(size: self.layer.frame.size, format: format).image { context in

             self.drawHierarchy(in: self.layer.bounds, afterScreenUpdates: true)
 
 */

/*
 let cropRect = mapVC.view.frame.inset(by: mapVC.view.safeAreaInsets).inset(by: mapVC.mapEdgeInsets)

 UIGraphicsBeginImageContextWithOptions(cropRect.size, false, 1.0)

 mapVC.view.drawHierarchy(in: mapVC.view.bounds afterScreenUpdates: true)
 

*/








let keyPoints = "PointsKey"
var KeyForUserDefaults = keyPoints + String(loadNum(KeyForUserDefaults: keyCurrentViewNum))


func savePoints(_ points: [[CGPoint]]) {
    let KeyForUserDefaults = keyPoints + String(loadNum(KeyForUserDefaults: keyCurrentViewNum))
    let data = points.map { try? JSONEncoder().encode($0) }
    UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
//    savePreviewImage()
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







//@State var currentViewNum = 0
//@State var maxViewNum = 0



let keyCurrentViewNum = "CurrentViewNumKey"
let keyMaxViewNum = "MaxViewNumKey"


func saveNum(_ num: Int, KeyForUserDefaults: String) {
//    let data = try! JSONEncoder().encode(num)
    UserDefaults.standard.set(num, forKey: KeyForUserDefaults)
    print("save")
}




func loadNum(KeyForUserDefaults: String) -> Int {
    
    let encodedData = UserDefaults.standard.integer(forKey: KeyForUserDefaults)
    
//    let encodedReturn = try! JSONDecoder().decode(Int.self, from: encodedData)
    print("load")
    print(KeyForUserDefaults)
    print(encodedData)
    return encodedData
}




let keyURL = "URLKEY"

func saveURL(_ myURL: [URL]) {
    let KeyForUserDefaults = keyURL
    let data = myURL.map { try? JSONEncoder().encode($0) }
    UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
//    savePreviewImage()
}


func loadURL() -> [URL] {
    let KeyForUserDefaults = keyURL
    
    guard let encodedData = UserDefaults.standard.array(forKey: KeyForUserDefaults) as? [Data] else {
        var returnN:[URL]=[]
        for i in 0...30{
            
        
            returnN.append(PreviewImage().path(fileNum: i))
        
        }
        return returnN
    }
    
    
    let encodedReturn = encodedData.map { try! JSONDecoder().decode(URL.self, from: $0) }
    return encodedReturn
}



//построю функцию которая копирует изображания все
//в конце будет 0 или 1
//это число хранится
//после сохранения оно меняется
//и при этом копируются все картинки
