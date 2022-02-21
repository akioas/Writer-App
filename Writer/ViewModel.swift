import SwiftUI


var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height

var currentLayer = 0
var pathVar = UIBezierPath() //draw shape
var drawMode = 1
var imageSize = CGSize(width: screenWidth+100, height: screenWidth+100)


var pathVarPreview = Array(repeating:UIBezierPath(),count:loadNum(KeyForUserDefaults: keyMaxViewNum)) //previews draw shape

var currentNum = 0
var currentLayerPreview = 0
var rectWidth: Double = screenWidth
var rectHeight: Double = screenHeight

var selected: Int = 0

func navigationFunction(points loadPoints: [[CGPoint]]){

    pathVar = UIBezierPath()
    currentLayer = points.count - 1
    if points.isEmpty == false{
        
        pathVar = UIBezierPath()
        currentLayer = points.count - 1
        if currentLayer < 0{
            currentLayer = 0
        }
        
        for currentNum in 0..<currentLayer{
            let firstPoint = points[currentNum].first
            
            if firstPoint != nil{
                pathVar.move(to: firstPoint!)
                for pointIndex in 1..<points[currentNum].count{
                    if ((pointIndex % 2 != 1) && (pointIndex > 0)) {
                        pathVar.addQuadCurve(to: points[currentNum][pointIndex], controlPoint: points[currentNum][pointIndex - 1])
                    }
                    
                }
            }
           
            
        }
        
        points.append([])
        currentLayer = points.count - 1
        if currentLayer < 0{
            currentLayer = 0
            points = [[]]
            pathVar = UIBezierPath()
           
        }
        
    } else{
        points = [[]]
        pathVar = UIBezierPath()

        currentLayer = 0
    }
}

func onAppearPreviewFunction(_ points: [[[CGPoint]]]){
    var pointsPreview = points
    
    pathVarPreview = Array(repeating:UIBezierPath(),count:loadNum(KeyForUserDefaults: keyMaxViewNum))
    let maxViewNum = loadNum(KeyForUserDefaults: keyMaxViewNum)
    for  num in 0..<maxViewNum{
        pointsPreview.removeAll{$0.isEmpty}
        if pointsPreview.count > num {
            
            for currentLayerPreview in 0...(pointsPreview[num].count - 1) {
               
                let firstPointPreview = pointsPreview[num][currentLayerPreview].first
               
                
                
                if firstPointPreview != nil{
                    pathVarPreview[num].move(to: firstPointPreview!)
                    for pointIndex in 1..<pointsPreview[num][currentLayerPreview].count{
                        if ((pointIndex % 2 != 1) && (pointIndex > 0)) {
                           
                        pathVarPreview[num].addQuadCurve(to: pointsPreview[num][currentLayerPreview][pointIndex], controlPoint: pointsPreview[num][currentLayerPreview][pointIndex - 1])
                        }
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
    

    pathVar = UIBezierPath()
    
    
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
                    
                    if ((pointIndex % 2 != 1) && (pointIndex > 0)) {
                        pathVar.addQuadCurve(to: points[currentNum][pointIndex], controlPoint: points[currentNum][pointIndex - 1])
                    }
                    
                }
            }
            
            
        }
        
        points.append([])
        currentLayer = points.count - 1
        if currentLayer < 0{
            currentLayer = 0
            points = [[]]
            pathVar = UIBezierPath()
        
        }
        
    } else{
        points = [[]]
        pathVar = UIBezierPath()
        currentLayer = 0
    }
    
    
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



func pathFunction(_ points: [[CGPoint]]) -> UIBezierPath{
    
    currentLayer = points.count - 1
    if currentLayer < 0{
        currentLayer = 0
    }
    currentNum = points.count - 1
        let firstPoint = points[currentNum].first
        
        if firstPoint != nil{
        
        pathVar.move(to: firstPoint!)
        for pointIndex in 0..<points[currentNum].count{
            if ((pointIndex % 2 != 1) && (pointIndex > 0)) {
                pathVar.addQuadCurve(to: points[currentNum][pointIndex], controlPoint: points[currentNum][pointIndex - 1])
            }
        }
        }
        
    
    return pathVar
}


func addFunction(){
    addModel()
    pathVarPreview.append(UIBezierPath())
}

func deleteFunction(_ num:Int){
    
    saveModel()
    pathVarPreview.remove(at: num)
    
}

func editView(){
    saveModel()
}


func backFunction(_ points: inout [[CGPoint]]){
    points.removeAll{$0.isEmpty}
    if points.isEmpty == false{
        if ((points.last?.isEmpty) == true)
        {
            points.removeLast()
        }
        if points.isEmpty == false{
            points.removeLast()
            
        }
        
        currentLayer = points.count - 1
        
        pathVar = UIBezierPath()
        if currentLayer  < 0 {
            points = [[]]
            pathVar = UIBezierPath()
            
            currentLayer = 0
        } else {
            currentLayer = points.count - 1
            for currentNum in 0...currentLayer{
                let firstPoint = points[currentNum].first
                
                
                pathVar.move(to: firstPoint!)
                for pointIndex in 1..<points[currentNum].count{
                    if ((pointIndex % 2 != 1) && (pointIndex > 0)) {
                        pathVar.addQuadCurve(to: points[currentNum][pointIndex], controlPoint: points[currentNum][pointIndex - 1])
                    }
                    
                }
                
              
            }
            
        }
        
        
        
        points.append([])
        currentLayer = points.count - 1
        
        
    } else{
        points = [[]]
        pathVar = UIBezierPath()
     
        currentLayer = 0
    }
}


