
import SwiftUI
import UIKit



var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height

var currentLayer = 0
var pathVar = Path()
var drawMode = 1 //

struct ContentView: View {

    @State var points: Array<[CGPoint]> = load()
    let imageSize: CGSize = CGSize(width: screenWidth, height: screenHeight)

    
    var body: some View {
        
        
        return GeometryReader { proxy in
                    if proxy.size.width < proxy.size.height {
        
        //
        VStack{//1
        ZStack {//2
           
           Rectangle()
                
                            .foregroundColor(.yellow)
                            .aspectRatio(1.0, contentMode: .fit)
            
            
//                           .frame(width: screenWidth, height: screenWidth)
//                           .edgesIgnoringSafeArea(.all)
                            .gesture(DragGesture().onChanged( {
                                
                                value in
                                self.addNewPoint(value)
                               
                                    })
                            .onEnded( { _ in
                                save(points)
                                if drawMode == 1{
                                    currentLayer = currentLayer + 1

                                points.append([])
                                
                                    print(points)
                                    
                                }
                            }))
            
           
            DrawShape(points: points)
            
                .stroke(lineWidth: 5)
                .foregroundColor(.black)
                .aspectRatio(1.0, contentMode: .fit)
        }//2

    
    
        HStack{
        Button("CLEAR"){
            clearButton()
        }
        Button("BACK"){
            backButton()
        }
            Button("CONTINUOUS"){
                continuousLine()

                         }
            Button("SAVE"){
                saveImage()

                         }
            
            
        }
        .background(Color(red: 0, green: 0.8, blue: 0.8))
        .foregroundColor(Color.black)
    }//1
                        
                    } else {
                        //
                        HStack{//1
                        ZStack {//2
                           
                           Rectangle()
                                
                                            .foregroundColor(.yellow)
                                            .aspectRatio(1.0, contentMode: .fit)
                            
                            
                //                           .frame(width: screenWidth, height: screenWidth)
                //                           .edgesIgnoringSafeArea(.all)
                                            .gesture(DragGesture().onChanged( {
                                                
                                                value in
                                                self.addNewPoint(value)
                                               
                                                    })
                                                        .onEnded( { _ in
                                                            save(points)
                                                            if drawMode == 1{
                                                                currentLayer = currentLayer + 1

                                                            points.append([])
                                                            
                                                                print(points)
                                                            }
                                                            }))
                            //
                            
                           
                            DrawShape(points: points)
                            
                                .stroke(lineWidth: 5)
                                .foregroundColor(.black)
                                .aspectRatio(1.0, contentMode: .fit)
                        }//2

                    
                    
                        VStack{
                        Button("CLEAR"){
                            clearButton()
                        }
                            Button("BACK"){
                                backButton()
                            }
                            Button("CONTINUOUS"){
                                continuousLine()
                            }
                            Button("SAVE"){
                                saveImage()

                                         }
                        }
                        .background(Color(red: 0, green: 0.8, blue: 0.8))
                        .foregroundColor(Color.black)
                    }//1
                    
        
        }
        }.background(Color(red: 0.6, green: 0.8, blue: 0.8))
        ////
    }
    
  
    func saveImage(){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let image = body.saveImage(size: imageSize).jpegData(
            compressionQuality: 0.8)
        let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        var fileName = "saveImageFile1"
        let fileURL = path.appendingPathComponent(fileName).appendingPathExtension("jpg")
        print(fileURL)

        do {
           let result = try image?.write(to: fileURL, options: .atomic)
        } catch let error {
            print(error)
        }


    }

    
    func addNewPoint(_ value: DragGesture.Value) {
                //
        var pointToAppend = value.location
        if (value.location.x < screenWidth)&&(value.location.y < screenWidth) {
//        points[currentLayer].append(value.location)
       
        //save(points)
        
        } else if (value.location.x > screenWidth)&&(value.location.y < screenWidth) {
            pointToAppend.x = screenWidth
        } else if (value.location.x < screenWidth)&&(value.location.y > screenWidth) {
            pointToAppend.y = screenWidth
        } else if (value.location.x > screenWidth)&&(value.location.y > screenWidth) {
            pointToAppend.x = screenWidth
            pointToAppend.y = screenWidth
        }
        
        if (value.location.y < 0){
            pointToAppend.y = 0
        }
        
        points[currentLayer].append(pointToAppend)
    }
    
    
    
    
    
    
    func continuousLine(){
        if drawMode == 1{
            drawMode = 0
        } else {
            drawMode = 1
            currentLayer = currentLayer + 1

        points.append([])
        }
    }
    
    func clearButton(){
        
            points = [[]]
            pathVar = Path()
            save(points)
            currentLayer = 0
    }


    func backButton(){
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
            }//backButton


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









extension UIView {
    func saveImage() -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: self.layer.frame.size, format: format).image { context in
            self.drawHierarchy(in: self.layer.bounds, afterScreenUpdates: true)
        }
    }
}
extension View {
    func saveImage(size: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        let image = controller.view.saveImage()
        return image
    }
}

/*

func clear() -> [CGPoint]{
    return []
}

*/



