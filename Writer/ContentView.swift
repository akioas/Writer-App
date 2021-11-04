
import SwiftUI
import UIKit

let layersMaxNum = 9
//var j = 0
var stopPoint: CGPoint = CGPoint(x:0, y:0)


struct ContentView: View {

    @State var points: [CGPoint] = load()

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
                                stopPoint = points.last!
                        print(stopPoint)
                                
                            }))
            
           
            
                
        
            
           
            DrawShape(points: points)
                .stroke(lineWidth: 5) // here you put width of lines
                .foregroundColor(.black)
            
            
        }

    }
    
    
        Button("CLEAR"){
            points = []
            Circle()
                        .foregroundColor(.blue)
                        .frame(width: 100, height: 100)
        }
    }
    private func addNewPoint(_ value: DragGesture.Value) {
                //

        points.append(value.location)
        save(points)
        
        
    }

}

struct DrawShape: Shape {

    var points: [CGPoint]
//    let layer = CAShapeLayer()
    
    
          
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let firstPoint = points.first else { return path
        }
        

        
        
            path.move(to: firstPoint)
                for pointIndex in 1..<points.count {
                    if points[pointIndex] != stopPoint{
                    path.addLine(to: points[pointIndex])
//                    save(points)
                    }
                }
            
                
            
        
        
        
        
        
        
        
        
        

        
            return path
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



func clear() -> [CGPoint]{
    return []
}

