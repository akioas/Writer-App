
import SwiftUI
import UIKit



var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height

var currentLayer = 0
var pathVar = Path()
var drawMode = 1 //
var imageSize = CGSize(width: screenWidth+100, height: screenWidth+100)


struct ContentView: View {
       var body: some View {
            NavigationView {
                VStack {
                    NavigationLink(destination: FirstView()) {
//                        Image(packageResource: "image", ofType: "jpg").resizable()
                        if #available(iOS 15.0, *) {
                            AsyncImage(url: PreviewImage().path())
                        } else {
                            // Fallback on earlier versions
                            Text(String(currentViewNum))
                                
                        }

                }.navigationBarTitle("Choose Drawing", displayMode: .inline)
            }
        }
    }
}





struct FirstView: View {
    
    @State var points: Array<[CGPoint]> = load()
    
    
    
    var body: some View {
        
        return ZStack {
            Color(.yellow)
                .ignoresSafeArea()
            GeometryReader { proxy in
                if proxy.size.width < proxy.size.height {
                    VStack{//1
                        drawView
                        hButtons
                        
                    }.background(Color(.yellow))
                    
                    
                } else {
                    //
                    HStack{//1
                        
                        
                        drawView
                        vButtons
                    }.background(Color(.yellow))
                    ////
                }
            }
            
        }
            
        
    }
    
    
    var drawView: some View {
        ZStack {//2
            
            Rectangle()
            
                .foregroundColor(.yellow)
                .aspectRatio(1.0, contentMode: .fit)
            
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
        
    }
    
    var hButtons: some View {
        HStack{
            Button("CLEAR"){
                clearButton()
            }.padding()
            Button("BACK"){
                backButton()
            }.padding()
            Button("CONTINUOUS"){
                continuousLine()
                
            }.padding()
            Button("SAVE"){
                saveImage()
                
            }.padding()
            
            /*
            Button("DELETE T"){
                deleteView(deletedViewNum: 1,  maxViewNum: 2)
            }
             */
            
            Button("SAVE PREVIEW"){
                PreviewImage().savePreviewImage()
                
            }.padding()
            
        }
        .background(Color(red: 0, green: 0.8, blue: 0.8))
        .foregroundColor(Color.black)
    }
    
    
    var vButtons: some View {
        VStack{
            Button("CLEAR"){
                clearButton()
            }.padding()
            Button("BACK"){
                backButton()
            }.padding()
            Button("CONTINUOUS"){
                continuousLine()
                
            }.padding()
            Button("SAVE"){
                saveImage()
                
            }.padding()
            
            
        }
        .background(Color(red: 0, green: 0.8, blue: 0.8))
        .foregroundColor(Color.black)
    }
    
    
    
    func saveImage(){

        let image = drawView.saveImage(size: imageSize)

        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        
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
        Group {
            ContentView()
            ContentView()
        }
    }
    
    
    
    
}


/*
 let res = str
 .components(separatedBy: " ")
 .map { CGPointFromString("{\($0)}") }
 */





//var viewNum = 0
//
var currentViewNum = 0
var maxViewNum = 1
//

let keyName = "WriterAppKey"


var KeyForUserDefaults = keyName + String(currentViewNum)







func save(_ points: [[CGPoint]]) {
    let data = points.map { try? JSONEncoder().encode($0) }
    UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
//    savePreviewImage()
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














