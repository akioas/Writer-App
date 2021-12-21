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


func refreshFunction(){
    let currentViewNum = loadNum(KeyForUserDefaults: keyCurrentViewNum)
    pathVarPreview[currentViewNum] = Path()
    pathVarPreview[currentViewNum] = pathVar
//    pathVarPreview.append(Path())
    
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


func onAppearPreviewFunction(_ pointsPreview: inout [[[CGPoint]]]){
    pathVarPreview = Array(repeating:Path(),count:loadNum(KeyForUserDefaults: keyMaxViewNum))
    let maxViewNum = loadNum(KeyForUserDefaults: keyMaxViewNum)
    for  num in 0..<maxViewNum{
        pointsPreview.removeAll{$0.isEmpty}
        if pointsPreview.count > num {
            
            for currentLayerPreview in 0...(pointsPreview[num].count - 1) {
                //                        guard let
                
                let firstPointPreview = pointsPreview[num][currentLayerPreview].first
                //                        else { return pathVarPreview[num]}
                
                
                if firstPointPreview != nil{
                    pathVarPreview[num].move(to: firstPointPreview!)
                    for pointIndex in 1..<pointsPreview[num][currentLayerPreview].count{
                        
                        pathVarPreview[num].addLine(to: pointsPreview[num][currentLayerPreview][pointIndex])
                        
                    }
                }
            }
        }
    }
}


func endDrawFunction(_ points: inout [[CGPoint]]){
    savePoints(points)
    if drawMode == 1{
        currentLayer = currentLayer + 1
        
        points.append([])
        
        print(points)
        
    }
}


func onAppearDrawFunction(_ points: inout [[CGPoint]]){
    
    
    saveNum(selected, KeyForUserDefaults: keyCurrentViewNum)
    
    
    points = loadPoints()
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
