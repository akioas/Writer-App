
import SwiftUI
import UIKit

//let layersMaxNum = 9
//var j = 0
//var stopPoint: CGPoint = CGPoint(x:0, y:0)
var currentLayer = 0
var pathVar = Path()

struct ContentView: View {

    @State var points: Array<[CGPoint]> = load()
    
    
    var body: some View {
        HStack{
        ZStack {
           
            
           Rectangle()
                            .foregroundColor(.yellow)
//                            .edgesIgnoringSafeArea(.all)
                            .gesture(DragGesture().onChanged( {
                                
                                value in
                                self.addNewPoint(value)
                               
                                    })
                            .onEnded( { _ in
//                                   points = []
                                
            //                    save(points)
//                                stopPoint = points[currentLayer].last!
//                        print(stopPoint)
                                save(points)
                               currentLayer = currentLayer + 1

                                points.append([])
                                
                                print(points)
//                                save(points)
                            }))
            
           
            
                
        
            
           
            DrawShape(points: points)
                .stroke(lineWidth: 5)
                .foregroundColor(.black)
            
            
        }

    }
    
        HStack{
        Button("CLEAR"){
            points = [[]]
            pathVar = Path()
            save(points)
            currentLayer = 0
            Circle()
                        .foregroundColor(.blue)
                        .frame(width: 100, height: 100)
        }
            Button("BACK"){
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
                    print(currentLayer)
                    print(points)
                    pathVar = Path()
                    if currentLayer  < 0 {
                        points = [[]]
                        pathVar = Path()
                        save(points)
                        currentLayer = 0
                    } else {
                        currentLayer = points.count - 1
                    for currentNum in 0...currentLayer{
                        let firstPoint = points[currentNum].first
                        
                        
                            pathVar.move(to: firstPoint!)
                            for pointIndex in 1..<points[currentNum].count{
                                       
                                        pathVar.addLine(to: points[currentNum][pointIndex])
                                        
                                    }
                            
                            save(points)
                        
                    }
                        
                }

                    
                     
                     points.append([])
                    currentLayer = points.count - 1
                    
                    
                } else{
                    points = [[]]
                    pathVar = Path()
                    save(points)
                    currentLayer = 0
                }
                
//                points.append([])
//                currentLayer = currentLayer + 1
                Circle()
                            .foregroundColor(.blue)
                            .frame(width: 100, height: 100)
            }
            
            
        }
    }
    func addNewPoint(_ value: DragGesture.Value) {
                //

        points[currentLayer].append(value.location)
       
        //save(points)
        
        
    }

}

struct DrawShape: Shape {

    var points: Array<[CGPoint]>
//    let layer = CAShapeLayer()
    
    
          
    func path(in rect: CGRect) -> Path {
        
        
        guard let firstPoint = points[currentLayer].first else { return pathVar
 
        }
        
            pathVar.move(to: firstPoint)
        for pointIndex in 1..<points[currentLayer].count{
                   
                    pathVar.addLine(to: points[currentLayer][pointIndex])
            save(points)
//                    save(points)
                    
                }
            
            
            
            return pathVar
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
    
    
    
}


/*
 let res = str
     .components(separatedBy: " ")
     .map { CGPointFromString("{\($0)}") }
 */






let KeyForUserDefaults = "drawKey"


func save(_ points: [[CGPoint]]) {
    let data = points.map { try? JSONEncoder().encode($0) }
    UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
}




func load() -> [[CGPoint]] {
    
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





/*

func clear() -> [CGPoint]{
    return []
}

*/
