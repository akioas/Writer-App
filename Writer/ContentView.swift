
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
//                                save(points)
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
func load() -> Array<[CGPoint]> {
    
    return [[]]
}*/

/*
 let res = str
     .components(separatedBy: " ")
     .map { CGPointFromString("{\($0)}") }
 */





let KeyForUserDefaults = "drawKey"
//let defaults = UserDefaults.standard
/*
func save(_ points: Array<[CGPoint]>) {
    let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: points, requiringSecureCoding: false)
    let userDefaults = UserDefaults.standard
    userDefaults.set(encodedData, forKey: KeyForUserDefaults)
}

func load() -> Array<[CGPoint]> {

    let decoded  = UserDefaults.standard.object(forKey: KeyForUserDefaults) as! Data
    let decodedReturn = try? NSKeyedUnarchiver.unarchivedObject(ofClass:Array<[CGPoint]>, from: decoded) as? [[CGPoint]]

    return decodedReturn!
}

*/

/*
func save<T: Codable>(_ value: [T]){
        let data = value.map { try? JSONEncoder().encode($0) }
        
    UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
    }
    
func load() -> Array<[CGPoint]> {
    guard let encodedData = UserDefaults.standard.array(forKey: KeyForUserDefaults) as? [Data] else {
        return []
        }
    let encReturn = encodedData.map { try! JSONDecoder().decode([CGPoint].self, from: $0)}
    return encReturn
    }*/

func save(_ points: [[CGPoint]]) {
    let data = points.map { try? JSONEncoder().encode($0) }
    UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
}

func load() -> [[CGPoint]] {
    
    guard let encodedData = UserDefaults.standard.array(forKey: KeyForUserDefaults) as? [Data] else {
        return []
    }

    
    let encodedReturn = encodedData.map { try! JSONDecoder().decode([CGPoint].self, from: $0) }
    currentLayer = encodedReturn.count - 1
    pathVar = Path()
    for currentNum in 0...currentLayer{
        guard let firstPoint = encodedReturn[currentNum].first else { return []

        }
        
            pathVar.move(to: firstPoint)
        for pointIndex in 1..<encodedReturn[currentNum].count{
                   
                    pathVar.addLine(to: encodedReturn[currentNum][pointIndex])
                    
                }
    }
    
    return encodedReturn
}



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
}
*/




func clear() -> [CGPoint]{
    return []
}

