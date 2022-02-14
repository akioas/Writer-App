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

func navigationFunction(points loadPoints: [[CGPoint]]){
   
//    selected = num
    pathVar = Path()
//    var points = loadPoints
    currentLayer = points.count - 1
    if points.isEmpty == false{
//        points.removeAll{$0.isEmpty}
        pathVar = Path()
        currentLayer = points.count - 1
        if currentLayer < 0{
            currentLayer = 0
        }
        
        for currentNum in 0..<currentLayer{
            let firstPoint = points[currentNum].first
            
            if firstPoint != nil{
                pathVar.move(to: firstPoint!)
                for pointIndex in 1..<points[currentNum].count{
                    
                    pathVar.addLine(to: points[currentNum][pointIndex])
                    
                }
            }
//            savePoints(points)
            
        }
        
        points.append([])
        currentLayer = points.count - 1
        if currentLayer < 0{
            currentLayer = 0
            points = [[]]
            pathVar = Path()
//            savePoints(points)
        }
        
    } else{
        points = [[]]
        pathVar = Path()
//        savePoints(points)
        currentLayer = 0
    }
}

func onAppearPreviewFunction(_ points: [[[CGPoint]]]){
    var pointsPreview = points
    print(points)
    print("?")
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





//share button
func actionSheetFunc() {
    let imgShare = FirstView().drawView.saveImage(size: imageSize)
        let activityVC = UIActivityViewController(activityItems: [imgShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }



func onAppearDrawFunction(_ points:inout [[CGPoint]]){
    
    
       saveNum(selected, KeyForUserDefaults: keyCurrentViewNum)
       print("APPEAR")
    pathVar = Path()
//       points = loadPoints()
    
    
       if points.isEmpty == false{
           points.removeAll{$0.isEmpty}
           points.append([])
           currentLayer = points.count - 1
        if currentLayer < 0 {
            currentLayer = 0
        }
           
           
           
           for currentNum in 0...currentLayer{
               let firstPoint = points[currentNum].first
               
               if firstPoint != nil{
                   pathVar.move(to: firstPoint!)
                   for pointIndex in 1..<points[currentNum].count{
                       
                       pathVar.addLine(to: points[currentNum][pointIndex])
                       
                   }
               }
               
//               savePoints(points)
               
           }
           
           points.append([])
           currentLayer = points.count - 1
           if currentLayer < 0{
               currentLayer = 0
               points = [[]]
               pathVar = Path()
//               savePoints(points)
           }
           
       } else{
           points = [[]]
           pathVar = Path()
//           savePoints(points)
           currentLayer = 0
       }
    
    
    
    
    /*
//    saveNum(selected, KeyForUserDefaults: keyCurrentViewNum)
    
//    FirstView().clearFunction(&points)
//    points = loadPoints()
    pathVar = Path()
    currentLayer = points.count - 1
    if currentLayer < 0{
        currentLayer = 0
    }
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
            
//            FirstView().editItem(points)
            
        }
        
        points.append([])
        currentLayer = points.count - 1
        if currentLayer < 0{
            currentLayer = 0
            points = [[]]
            pathVar = Path()
//            FirstView().editItem(points)
        }
        
    } else{
        points = [[]]
        pathVar = Path()
//        FirstView().editItem(points)
        currentLayer = 0
    }*/
}



func addNewPointFunction(_ points: inout [[CGPoint]], value: DragGesture.Value){
    //if index out of range
    while (points.count - 1) < currentLayer{
        points.append([])
    }
    points[currentLayer].append(addPoint(value))
    
}


func continuousLineFunction(_ points: inout [[CGPoint]]){
    if drawMode == 1{
        colorContinuous = .red
        
        drawMode = 0
    } else {
        drawMode = 1
        colorContinuous = .black
        
        currentLayer = currentLayer + 1
        
        points.append([])
    }
}


/*

func pathFunction(_ points: [[CGPoint]]) -> Path{
    currentLayer = points.count - 1
    if currentLayer < 0{
        currentLayer = 0
    }
    if !points.isEmpty{
    guard let firstPoint = points[currentLayer].first else { return pathVar
        
    }
    
    pathVar.move(to: firstPoint)
    for pointIndex in 1..<points[currentLayer].count{
        
        pathVar.addLine(to: points[currentLayer][pointIndex])
        FirstView().editItem(points)
        
        
    }
    return pathVar
    }
    else {
        return Path()
    }
}*/

func pathFunction(_ points: [[CGPoint]]) -> Path{
    
    currentLayer = points.count - 1
    if currentLayer < 0{
        currentLayer = 0
    }
    if !points.isEmpty{
    guard let firstPoint = points[currentLayer].first else { return pathVar
        
    }
//        FirstView().editItem(points)
        print("??????")
    pathVar.move(to: firstPoint)
    for pointIndex in 1..<points[currentLayer].count{
        
        pathVar.addLine(to: points[currentLayer][pointIndex])
        
        
        
    }
    }
    return pathVar
}

func getPoints() -> [[CGPoint]]{
    print("ggg")
    return points
}
