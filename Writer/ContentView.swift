
import SwiftUI
import UIKit



struct ContentView: View {
    
    
    @State var currentViewNum:Int = loadNum(KeyForUserDefaults: keyCurrentViewNum)
    @State var maxViewNum:Int = loadNum(KeyForUserDefaults: keyMaxViewNum)
    @State var points = loadPoints()
    @State var pointsPreview = loadPointsForPreview()
    
    
    var body: some View {
        
        
        NavigationView {
            VStack{
                
                Button(action: {
                    self.maxViewNum = maxViewNum + 1
                    saveNum(maxViewNum, KeyForUserDefaults: keyMaxViewNum)
                    pointsPreview.append([[]])
                }) {
                    
                    Image(systemName: "plus")
                }
 
                ForEach(0..<maxViewNum, id: \.self)
                {
                    num in
                    NavigationLink(destination: FirstView())
                    {
                        drawView(num:num)
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        self.navigationFunction(num: num)
                    })
                    
                    Button(action:{
                        _ = deleteView(deletedViewNum: num, maxViewNum: maxViewNum)
                        maxViewNum = maxViewNum - 1
                    })
                    {
                        Image(systemName: "trash.circle.fill")
                    }
                  
                }

                Text(" ")//?
 
            }

        }.navigationBarTitle("Choose Drawing", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        
    }
    
    func navigationFunction(num: Int){

        selected = num
        self.currentViewNum = num
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
    

   
    
    func drawView(num:Int) -> some View {
        ZStack {
            DrawShape(pointsPreviewArray: pointsPreview, num: num)
            
                .stroke(lineWidth: 5)
                .foregroundColor(.black)
                .scaleEffect(CGSize(width: 1/(Double(maxViewNum) ) ,height: 1/Double(maxViewNum) ) )
                .padding()
  
        }
    }
    

    
    struct DrawShape: Shape {

        var pointsPreviewArray: Array<[[CGPoint]]>
        var num: Int
        
        func path(in rect: CGRect) -> Path {
               
            var pointsPreview = pointsPreviewArray

            pointsPreview.removeAll{$0.isEmpty}
            if pointsPreview.count > num {
              
                for currentLayerPreview in 0...(pointsPreview[num].count - 1) {
                    guard let firstPointPreview = pointsPreview[num][currentLayerPreview].first else { return pathVarPreview
                        
                    }
                    
                    pathVarPreview.move(to: firstPointPreview)
                    for pointIndex in 1..<pointsPreview[num][currentLayerPreview].count{
                        
                        pathVarPreview.addLine(to: pointsPreview[num][currentLayerPreview][pointIndex])
 
                    }
                }
            }
            
            let varReturn = pathVarPreview
            pathVarPreview = Path()
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
                        .simultaneousGesture(TapGesture().onEnded{
                            
                            presentationMode.wrappedValue.dismiss()
                            
                        })
                    
                    
                
                        
                    }.background(Color(.yellow))
                }
                         else {
                 
                    HStack{//1
                        
                        
                        drawView
                        vButtons
                        NavigationLink(destination: ContentView()) {
                            Text("Choose drawing")
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            
                            presentationMode.wrappedValue.dismiss()
                            
                        })
                        
                    }.background(Color(.yellow))
                        
                    
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
            Button(action: {
                Writer.actionSheet()
                        }) {
                            Text("SHARE")
                        }
        
            
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
  
        func path(in rect: CGRect) -> Path {

            currentLayer = points.count - 1
            guard let firstPoint = points[currentLayer].first else { return pathVar
                
            }
            
            pathVar.move(to: firstPoint)
            for pointIndex in 1..<points[currentLayer].count{
                
                pathVar.addLine(to: points[currentLayer][pointIndex])
                savePoints(points)
   
                
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









func actionSheet() {
    let imgShare = FirstView().drawView.saveImage(size: imageSize)
        let activityVC = UIActivityViewController(activityItems: [imgShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
