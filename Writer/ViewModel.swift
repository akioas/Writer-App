import SwiftUI


var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height

var currentLayer = 0
var pathVar = Path() //draw shape
var drawMode = 1
var imageSize = CGSize(width: screenWidth+100, height: screenWidth+100)


var pathVarPreview = Array(repeating:Path(),count:loadNum(KeyForUserDefaults: keyMaxViewNum)) //previews draw shape

var currentNum = 0
var currentLayerPreview = 0
var rectWidth: Double = screenWidth
var rectHeight: Double = screenHeight

var selected: Int = 0






//share button
func actionSheet() {
    let imgShare = FirstView().drawView.saveImage(size: imageSize)
        let activityVC = UIActivityViewController(activityItems: [imgShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }



func deleteButton(_ num: Int, maxViewNum: inout Int){
   _ = deleteView(deletedViewNum: num, maxViewNum: maxViewNum)
    maxViewNum -= 1
   saveNum(maxViewNum, KeyForUserDefaults: keyMaxViewNum)
    
    for viewNum in num..<maxViewNum{
        pathVarPreview[viewNum] = Path()
    
        saveNum(viewNum,KeyForUserDefaults: keyCurrentViewNum)
        var points = loadPoints()
        currentLayer = points.count - 1
        if points.isEmpty == false{
            points.removeAll{$0.isEmpty}
            
            pathVar = Path()
            
            
            for currentNum in 0..<currentLayer{
                let firstPoint = points[currentNum].first
                
                if firstPoint != nil{
                    pathVar.move(to: firstPoint!)
                    for pointIndex in 1..<points[currentNum].count{
                        
                        pathVar.addLine(to: points[currentNum][pointIndex])
                        
                    }
                }
                
                savePoints(points)
                
            }
            
            points.append([])
            currentLayer = points.count - 1
            if currentLayer < 0{
                currentLayer = 0
                points = [[]]
                pathVar = Path()
                savePoints(points)
            }
            
        } else{
            points = [[]]
            pathVar = Path()
            savePoints(points)
            currentLayer = 0
        }

        pathVarPreview[viewNum] = pathVar
       
    }

    pathVarPreview.append(Path())
}


func refreshFunction(currentViewNum: Int){
    
    pathVarPreview[currentViewNum] = Path()
    pathVarPreview[currentViewNum] = pathVar
    pathVarPreview.append(Path())
    
}


func plusFunction(currentViewNum: Int){
    let maxViewNum = loadNum(KeyForUserDefaults: keyMaxViewNum)
    saveNum(maxViewNum, KeyForUserDefaults: keyMaxViewNum)
    if pathVarPreview.isEmpty {
        pathVarPreview = [Path()]
    }
    pathVarPreview[currentViewNum] = Path()
    pathVarPreview[currentViewNum] = pathVar
    pathVarPreview.append(Path())
}



func navigationFunction(_ num: Int){
    selected = num
    saveNum(selected, KeyForUserDefaults: keyCurrentViewNum)
    var points = loadPoints()
    currentLayer = points.count - 1
    if points.isEmpty == false{
        points.removeAll{$0.isEmpty}
        pathVar = Path()
        
        
        for currentNum in 0..<currentLayer{
            let firstPoint = points[currentNum].first
            
            if firstPoint != nil{
                pathVar.move(to: firstPoint!)
                for pointIndex in 1..<points[currentNum].count{
                    
                    pathVar.addLine(to: points[currentNum][pointIndex])
                    
                }
            }
            savePoints(points)
            
        }
        
        points.append([])
        currentLayer = points.count - 1
        if currentLayer < 0{
            currentLayer = 0
            points = [[]]
            pathVar = Path()
            savePoints(points)
        }
        
    } else{
        points = [[]]
        pathVar = Path()
        savePoints(points)
        currentLayer = 0
    }
}
