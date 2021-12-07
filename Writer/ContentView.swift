
import SwiftUI
import UIKit



var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height

var currentLayer = 0
var pathVar = Path()
var drawMode = 1
var imageSize = CGSize(width: screenWidth+100, height: screenWidth+100)


var pathVarPreview = Path()
var currentNum = 0
var currentLayerPreview = 0
var rectWidth: Double = screenWidth
var rectHeight: Double = screenHeight

//     BACK



var selected: Int = 0


struct ContentView: View {
    
    
    @State var currentViewNum:Int = loadNum(KeyForUserDefaults: keyCurrentViewNum)
    @State var maxViewNum:Int = loadNum(KeyForUserDefaults: keyMaxViewNum)
    //    @State var buttonVar: Bool = false
    //    @State var imgURL: [URL] = PreviewImage().path(fileNum: loadNum(KeyForUserDefaults: keyCurrentViewNum))
    //    @State var imgURL: [URL] = loadURL()
    @State var points = loadPoints()
    @State var pointsPreview = loadPointsForPreview()
    
    
    //    @State var URLStoSave:[URL] = []
    var body: some View {
        
        
        
        
        NavigationView {
            VStack{
                //                Text(" ")
                //                NavigationView {
                Button(action: {
                    self.maxViewNum = maxViewNum + 1
                    //                    self.currentViewNum = maxViewNum
                    //                    saveViewNum(currentViewNum, KeyForUserDefaults: keyCurrentViewNum)
                    saveNum(maxViewNum, KeyForUserDefaults: keyMaxViewNum)
                    print(currentViewNum)
                    pointsPreview.append([[]])
                }) {
                    
                    Image(systemName: "plus")
                    //                    NavigationLink(destination: FirstView()) {
                    
                    //                    }
                    
                    //                     .navigationBarBackButtonHidden(true)
                    //                     .navigationBarHidden(true)
                }
                
                
                
                
                
                //problem Button to NavLink
                ForEach(0..<maxViewNum, id: \.self)
                {
                    num in
                    
                    //                        NavigationView {
                    
                    NavigationLink(destination: FirstView())
                    {
                        //link
                        
                        
                        
                        
                        //let numURL = imgURL[num]
                        
                        //                        Text(String(num))
                        drawView(num:num)
                        
                        
                        
                        
                    }.simultaneousGesture(TapGesture().onEnded{
                        self.butFun(num: num)
                        
                        
                        
                    }
                                          
                                          //                        showingDetail = true
                                          
                                          //                            print("!!!!")
                                          //                            print(num)
                                          //                            self.currentViewNum = num
                                          //                            print(currentViewNum)
                    )
                    
                    
                    
                    Button(action:{
                        _ = deleteView(deletedViewNum: num, maxViewNum: maxViewNum)
                        maxViewNum = maxViewNum - 1
                    }){
                        Image(systemName: "trash.circle.fill")
                    }
                    //                        .frame( alignment: )
                }
                
                
                Text(" ")//?
                
                
                
            }
            
            
        }.navigationBarTitle("Choose Drawing", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        
    }
    
    func butFun(num: Int){
        print("num")
        print(num)
        //                            self.currentViewNum = num
        selected = num
        self.currentViewNum = selected
        print("selected")
        print(selected)
        saveNum(selected, KeyForUserDefaults: keyCurrentViewNum)
        print("current")
        print("current")
        print("current")
        print("current")
        print("current")
        print("current")
        print(currentViewNum)
        
        
        
        
        points = loadPoints()
        currentLayer = points.count - 1
        if points.isEmpty == false{
            points.removeAll{$0.isEmpty}
            
            //                currentLayer = points.count - 1
            print(currentLayer)
            print(points)
            pathVar = Path()
            
            
            for currentNum in 0..<currentLayer{
                let firstPoint = points[currentNum].first
                
                if firstPoint != nil{
                    pathVar.move(to: firstPoint!)
                    for pointIndex in 1..<points[currentNum].count{
                        
                        pathVar.addLine(to: points[currentNum][pointIndex])
                        
                    }
                } else {
                    //                            pathVar = Path()
                    
                }
                
                savePoints(points)
                
                
                
            }
            
            
            
            points.append([])
            currentLayer = points.count - 1
            if currentLayer < 0{
                currentLayer = 0
                points = [[]]
                pathVar = Path()
                savePoints(points)
            }
            
        } else{
            points = [[]]
            pathVar = Path()
            savePoints(points)
            currentLayer = 0
        }
        
        
        
    }
    
    
    /*
     func drawOnAppear(num:Int){
     
     var pointsPreview = loadPointsFirst(num: num)
     currentLayer = pointsPreview.count - 1
     
     if pointsPreview.isEmpty == false{
     pointsPreview.removeAll{$0.isEmpty}
     
     
     
     
     for currentNum in 0..<currentLayer{
     let firstPoint = pointsPreview[currentNum].first
     
     if firstPoint != nil{
     pathVarPreview.move(to: firstPoint!)
     for pointIndex in 1..<pointsPreview[currentNum].count{
     
     pathVarPreview.addLine(to: pointsPreview[currentNum][pointIndex])
     
     }
     }
     
     
     
     }
     
     pointsPreview.append([])
     currentLayer = pointsPreview.count - 1
     if currentLayer < 0{
     currentLayer = 0
     pointsPreview = [[]]
     pathVarPreview = Path()
     
     }
     
     } else{
     pointsPreview = [[]]
     pathVarPreview = Path()
     
     currentLayer = 0
     }
     
     }
     */
    
    func drawView(num:Int) -> some View {
        ZStack {//2
            /*
             GeometryReader { (geometry) in
             self.makeView(geometry)
             }
             */
            DrawShape(pointsPreviewArray: pointsPreview, num: num)
            
                .stroke(lineWidth: 5)
                .foregroundColor(.black)
                .scaleEffect(CGSize(width: 1/(Double(maxViewNum) ) ,height: 1/Double(maxViewNum) ) )
                .padding()
            
            
        }
    }
    func makeView(_ geometry: GeometryProxy) -> some View {
        rectWidth = geometry.size.width / Double(maxViewNum) //- 20
        rectHeight = geometry.size.height / Double(maxViewNum) //- 20
        if maxViewNum < 2 {
            rectWidth = rectWidth / Double(2)
            rectHeight = rectHeight / Double(2)
        }
        
        //            DispatchQueue.main.async { self.frame = geometry.size }
        
        return
        Rectangle()
        
            .foregroundColor(.yellow)
            .aspectRatio(1.0, contentMode: .fit)
        
        //
        //                    .frame(width: rectWidth, alignment: .bottomLeading)
    }
    
    
    /*
     var Rect: some View{
     Rectangle()
     
     .foregroundColor(.yellow)
     .aspectRatio(1.0, contentMode: .fit)
     }*/
    
    
    
    struct DrawShape: Shape {
        
        
        
        var pointsPreviewArray: Array<[[CGPoint]]>
        //    let layer = CAShapeLayer()
        
        //        var size: CGSize
        var num: Int
        
        func path(in rect: CGRect) -> Path {
            /*
             var pointsCurrent = pointsPreview
             for num in 0..<currentLayerPreview{
             for number in 0..<pointsCurrent[num].count {
             pointsCurrent[num][number] = CGPointMultiply(pointsCurrent[num][number], multiply:0.001)
             }
             */
            //            }
            var pointsPreview = pointsPreviewArray
            print("num")
            print(num)
            var pointer = num - 1
            pointsPreview.removeAll{$0.isEmpty}
            if pointsPreview.count > num {
                //                pointsPreview[num] = [[]]
                /*
                 if !pointsPreview[num].isEmpty {
                 */
                for currentLayerPreview in 0...(pointsPreview[num].count - 1) {
                /*
                if currentLayerPreview < 0 {
                    currentLayerPreview = 0
                }*/
                
                guard let firstPointPreview = pointsPreview[num][currentLayerPreview].first else { return pathVarPreview
                    
                }
                
                pathVarPreview.move(to: firstPointPreview)
                for pointIndex in 1..<pointsPreview[num][currentLayerPreview].count{
                    
                    pathVarPreview.addLine(to: pointsPreview[num][currentLayerPreview][pointIndex])
                    //                    save(points)
                }
            }
            }
            //            }
            
            let varReturn = pathVarPreview
            pathVarPreview = Path()
            //                .applying(CGAffineTransform(scaleX: 0.0050, y: 0.0050))
            return varReturn
            
        }
        
    }
    
    
    
}













struct FirstView: View {
    @State var currentViewNum:Int = loadNum(KeyForUserDefaults: keyCurrentViewNum)
    @State var points: Array<[CGPoint]> = loadPoints()
    @Environment(\.presentationMode) var presentationMode
    
    
    
    
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
                        .simultaneousGesture(TapGesture().onEnded{
                            
                            presentationMode.wrappedValue.dismiss()
                            
                        })
                    
                    
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
        //h
        .onAppear {
            drawOnAppear()
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
                PreviewImage().savePreviewImage(fileNum: loadNum(KeyForUserDefaults: keyCurrentViewNum))
                let imgURL = PreviewImage().path(fileNum: loadNum(KeyForUserDefaults: keyCurrentViewNum))
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func drawOnAppear(){
        
        self.currentViewNum = selected
        
        saveNum(selected, KeyForUserDefaults: keyCurrentViewNum)
        
        
        points = loadPoints()
        currentLayer = points.count - 1
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
                
                savePoints(points)
                
            }
            
            points.append([])
            currentLayer = points.count - 1
            if currentLayer < 0{
                currentLayer = 0
                points = [[]]
                pathVar = Path()
                savePoints(points)
            }
            
        } else{
            points = [[]]
            pathVar = Path()
            savePoints(points)
            currentLayer = 0
        }
        
    }
    
    
    
    
    
    func addNewPoint(_ value: DragGesture.Value) {
        
        var pointToAppend = value.location
        if (value.location.x < screenWidth)&&(value.location.y < screenWidth) {
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
            
            print(points)
            currentLayer = points.count - 1
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








func CGPointMultiply (_ point : CGPoint , multiply : CGFloat) -> CGPoint {
    return CGPoint(x: point.x * multiply, y: point.y * multiply)
}

