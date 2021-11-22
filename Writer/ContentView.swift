
import SwiftUI
import UIKit



var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height

var currentLayer = 0
var pathVar = Path()
var drawMode = 1 //
var imageSize = CGSize(width: screenWidth+100, height: screenWidth+100)



//var imgURL = PreviewImage().path(fileNum: ContentView().currentViewNum)




struct ContentView: View {
    
    
    @State var currentViewNum:Int = loadViewNum(KeyForUserDefaults: keyCurrentViewNum)
    @State var maxViewNum:Int = loadViewNum(KeyForUserDefaults: keyMaxViewNum)
    
    @State var selected: Int = 0
    
    
    var body: some View {
        
        var imgURL: URL = PreviewImage().path(fileNum: loadViewNum(KeyForUserDefaults: keyCurrentViewNum))
        
        
        NavigationView {
            VStack{
                Button(action: {
                    self.maxViewNum = maxViewNum + 1
                    self.currentViewNum = maxViewNum
                    saveViewNum(currentViewNum, KeyForUserDefaults: keyCurrentViewNum)
                    saveViewNum(maxViewNum, KeyForUserDefaults: keyMaxViewNum)
                    print(currentViewNum)
                 }) {
                     Text("+")
                     NavigationLink(destination: FirstView()) {
                     
                     }
                     
//                     .navigationBarBackButtonHidden(true)
//                     .navigationBarHidden(true)
                 }
                 
                     
                
                HStack {
                    
                    ForEach(0..<maxViewNum, id: \.self){num in
                        Button(action: {
                            print("num")
                            print(num)
                            self.currentViewNum = num
                            selected = num
                            print("selected")
                            print(selected)
                            saveViewNum(num, KeyForUserDefaults: keyCurrentViewNum)
                            print(currentViewNum)

                        }) {    Text(String(currentViewNum))
                            NavigationLink(destination: FirstView()) {
                            if #available(iOS 15.0, *) {
                                AsyncImage(url: PreviewImage().path(fileNum: num),scale:2.0)
                                
                                { image in
                                           image
                                               .resizable()
                                               .aspectRatio(contentMode: .fit)
                                       } placeholder: {
                                           Image(systemName: "photo")
                                               .imageScale(.large)
                                               .foregroundColor(.gray)
                                       }
                                
                            } else {
                                // Fallback on earlier versions
                            }
                            
                        }}/*{
                             NavigationLink(destination: FirstView()) {
                                 if #available(iOS 15.0, *) {
                                     AsyncImage(url: PreviewImage().path(fileNum: loadViewNum(KeyForUserDefaults: keyCurrentViewNum)),scale:2.0)
                                 } else {
                                     // Fallback on earlier versions
                                 }
                                 
                             }
                             
                             }*/
                        
                    
                }
            }
                
                //                        Image(packageResource: "image", ofType: "jpg").resizable()
                
                
            }
            
        }.navigationBarTitle("Choose Drawing", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }
    
    
}







struct FirstView: View {
    
    @State var points: Array<[CGPoint]> = loadPoints()
    
    
    
    var body: some View {
        
        return ZStack {
            Color(.yellow)
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                if proxy.size.width < proxy.size.height {
                    VStack{//1
                        
                        drawView
                        hButtons
                        NavigationLink(destination: ContentView()) {
                            Text("Choose drawing")
                        }
                        
                    }.background(Color(.yellow))
                    
                    
                } else {
                    //
                    HStack{//1
                        
                        
                        drawView
                        vButtons
                        NavigationLink(destination: ContentView()) {
                            Text("Choose drawing")
                        }
                    }.background(Color(.yellow))
                    ////
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
        
        
        
        
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
                    savePoints(points)
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
                PreviewImage().savePreviewImage(fileNum: loadViewNum(KeyForUserDefaults: keyCurrentViewNum))
                let imgURL = PreviewImage().path(fileNum: loadViewNum(KeyForUserDefaults: keyCurrentViewNum))
                print(imgURL)
                
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
        savePoints(points)
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
                savePoints(points)
                currentLayer = 0
            } else {
                currentLayer = points.count - 1
                for currentNum in 0...currentLayer{
                    let firstPoint = points[currentNum].first
                    
                    
                    pathVar.move(to: firstPoint!)
                    for pointIndex in 1..<points[currentNum].count{
                        
                        pathVar.addLine(to: points[currentNum][pointIndex])
                        
                    }
                    
                    savePoints(points)
                    
                }
                
            }
            
            
            
            points.append([])
            currentLayer = points.count - 1
            
            
        } else{
            points = [[]]
            pathVar = Path()
            savePoints(points)
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
                savePoints(points)
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










//placeholder image
