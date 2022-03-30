import SwiftUI


var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height

var currentLayer = 0
var pathVar = Path() //draw shape
var drawMode = 1
var imageSize = CGSize(width: screenWidth+100, height: screenWidth+100)

let userdef = Defaults()
var pathVarPreview = Array(repeating:Path(),count:userdef.loadNum(KeyForUserDefaults: keyMaxViewNum)) //previews draw shape

var currentNum = 0
var currentLayerPreview = 0
var rectWidth: Double = screenWidth
var rectHeight: Double = screenHeight

var selected: Int = 0


class Appear{
    func navigationFunction(points loadPoints: [[CGPoint]]){

        pathVar = Path()
        currentLayer = points.count - 1
        if points.isEmpty == false{
            
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
               
                
            }
            
            points.append([])
            currentLayer = points.count - 1
            if currentLayer < 0{
                currentLayer = 0
                points = [[]]
                pathVar = Path()
               
            }
            
        } else{
            points = [[]]
            pathVar = Path()

            currentLayer = 0
        }
    }

    func onAppearPreviewFunction(_ points: [[[CGPoint]]]){
        var pointsPreview = points
        
        pathVarPreview = Array(repeating:Path(),count:userdef.loadNum(KeyForUserDefaults: keyMaxViewNum))
        let maxViewNum = userdef.loadNum(KeyForUserDefaults: keyMaxViewNum)
        for  num in 0..<maxViewNum{
            pointsPreview.removeAll{$0.isEmpty}
            if pointsPreview.count > num {
                
                for currentLayerPreview in 0...(pointsPreview[num].count - 1) {
                   
                    let firstPointPreview = pointsPreview[num][currentLayerPreview].first
                   
                    
                    
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








    func onAppearDrawFunction(_ points:inout [[CGPoint]]){
        

        pathVar = Path()
        
        
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
                
                
            }
            
            points.append([])
            currentLayer = points.count - 1
            if currentLayer < 0{
                currentLayer = 0
                points = [[]]
                pathVar = Path()
            
            }
            
        } else{
            points = [[]]
            pathVar = Path()
            currentLayer = 0
        }
        
        
    }
    
    
    
    
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
                
                
                
            }
        }
            return pathVar
    }
    




}

class AddingPoints{
    func addNewPointFunction(_ points: inout [[CGPoint]], value: DragGesture.Value){
        //if index out of range
        while (points.count - 1) < currentLayer{
            points.append([])
        }
        points[currentLayer].append(PointModel().addPoint(value))

    }

}


class Buttons{
    
    
    

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

    

    func addFunction(){
        DataModel().addModel()
        pathVarPreview.append(Path())
    }

    func deleteFunction(_ num:Int){
        
        DataModel().saveModel()
        pathVarPreview.remove(at: num)
        
    }

    func editView(){
        DataModel().saveModel()
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
            pathVar = Path()
            if currentLayer  < 0 {
                points = [[]]
                pathVar = Path()
                
                currentLayer = 0
            } else {
                currentLayer = points.count - 1
                for currentNum in 0...currentLayer{
                    let firstPoint = points[currentNum].first
                    
                    
                    pathVar.move(to: firstPoint!)
                    for pointIndex in 1..<points[currentNum].count{
                        
                        pathVar.addLine(to: points[currentNum][pointIndex])
                        
                    }
                    
                  
                }
                
            }
            
            
            
            points.append([])
            currentLayer = points.count - 1
            
            
        } else{
            points = [[]]
            pathVar = Path()
         
            currentLayer = 0
        }
    }


    //share button
    func actionSheetFunc() {
        let imgShare = FirstView().drawView.saveImage(size: imageSize)
        let activityVC = UIActivityViewController(activityItems: [imgShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}
