
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
                            .edgesIgnoringSafeArea(.all)
                            .gesture(DragGesture().onChanged( {
                                
                                value in
                                self.addNewPoint(value)
                               
                                    })
                            .onEnded( { _ in
//                                   points = []
                                
            //                    save(points)
//                                stopPoint = points[currentLayer].last!
//                        print(stopPoint)
                               currentLayer = currentLayer + 1
                                points.append([])
                                print(points)
                            }))
            
           
            
                
        
            
           
            DrawShape(points: points)
                .stroke(lineWidth: 5)
                .foregroundColor(.black)
            
            
        }

    }
    
    
        Button("CLEAR"){
            points = [[]]
            pathVar = Path()
            currentLayer = 0
            Circle()
                        .foregroundColor(.blue)
                        .frame(width: 100, height: 100)
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

func load() -> Array<[CGPoint]> {
    
    return [[]]
}

/*
 let res = str
     .components(separatedBy: " ")
     .map { CGPointFromString("{\($0)}") }
 */



/*

let KeyForUserDefaults = "drawKey"

func save(_ points: Array<[CGPoint]>) {
    let data = points.map { try? JSONEncoder().encode($0) }
    UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
}

func load() -> Array<[CGPoint]> {
    guard let encodedData = UserDefaults.standard.array(forKey: KeyForUserDefaults) as? [Data] else {
        return []
    }

    return encodedData.map { try! JSONDecoder().decode([CGPoint].self, from: $0) }
}*/

/*
func save(_ points: [CGPoint]) {
    let data = points.map { try? JSONEncoder().encode($0) }
    UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
}

func load() -> [CGPoint] {
    guard let encodedData = UserDefaults.standard.array(forKey: KeyForUserDefaults) as? [Data] else {
        return []
    }

    return encodedData.map { try! JSONDecoder().decode(CGPoint.self, from: $0) }
}*/








func clear() -> [CGPoint]{
    return []
}

