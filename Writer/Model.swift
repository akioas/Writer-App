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
var KeyForUserDefaults = keyPoints + String(loadNum(KeyForUserDefaults: keyCurrentViewNum))


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
    saveNum(maxViewNum - 1, KeyForUserDefaults: keyMaxViewNum)
    if deletedViewNum == maxViewNum{
        let keyToDelete = keyPoints + String(deletedViewNum)
        UserDefaults.standard.removeObject(forKey: keyToDelete)
            
    }
    else {
        for viewNum in deletedViewNum...(maxViewNum - 1){
            let keyToDelete = keyPoints + String(viewNum)
            //
            let keyToReassign = keyPoints + String(viewNum+1)
            guard let encodedData = UserDefaults.standard.array(forKey: keyToReassign) as? [Data] else {
                return [[]]
            }
            
            let encodedReturn = encodedData.map { try! JSONDecoder().decode([CGPoint].self, from: $0) }
            
            let data = encodedReturn.map { try? JSONEncoder().encode($0) }
            UserDefaults.standard.set(data as Any?, forKey: keyToDelete)
            //
        }
        let keyToDelete = keyPoints + String(maxViewNum)
        UserDefaults.standard.removeObject(forKey: keyToDelete)
        
    }
    return [[]]
}








/*

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


*/





/*

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
    
    



}

*/
