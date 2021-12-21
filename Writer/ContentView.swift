
import SwiftUI
import UIKit



struct ContentView: View {
    
    
    @State var currentViewNum:Int = loadNum(KeyForUserDefaults: keyCurrentViewNum)
    @State var maxViewNum:Int = loadNum(KeyForUserDefaults: keyMaxViewNum)
    @State var points = loadPoints()
    @State var pointsPreview = loadPointsForPreview()
    @State private var timeElapsed = false
    
    var body: some View {
        ZStack{
            Color(.yellow)
                .ignoresSafeArea()
            NavigationView {
                VStack{
                    HStack{
                        //new image
                        Button(action: {
                            plusButton()
                            
                        }) {
                            
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        Spacer()
                            .frame(width: 50)
                        //refresh previews
                        Button(action:{
                            
                            refreshButton()
                            
                        }){
                            Image(systemName: "gobackward")
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                        }
                    }
                    ScrollView {
                        
                        //previews
                        ForEach(0..<maxViewNum, id: \.self)
                        {
                            num in
                            NavigationLink(destination: FirstView())
                            {
                                drawView(num:num)
                                    .frame(width: screenWidth*0.8, height: screenWidth*0.8)
                                    .background(Rectangle()
                                                    .foregroundColor(Color.yellow))
                            }
                            .simultaneousGesture(TapGesture().onEnded{
                                self.navigationButton(num)
                            })
                            ZStack{
                                Button(action:{
                                    deleteButton(num, maxViewNum:&maxViewNum)
                                })
                                {
                                    Image(systemName: "trash.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                }
                            }
                        }
                    }
                    
                    
                    
                }
                
            }.navigationBarTitle("Choose Drawing", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .onAppear(perform: {
                    //
                    
                    drawOnAppear()
                    
                })
        }
    }
    
    
    func delay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            timeElapsed = true
        }
    }
    
    func refreshButton(){
        
        delay()
        pointsPreview = loadPointsForPreview()
        refreshFunction()
//        pointsPreview.append([[]])
        
        
    }
    
    
    
    func plusButton(){
        plusFunction(currentViewNum: currentViewNum)
        pointsPreview.append([[]])
    }
    
    //to draw view
    func navigationButton(_ num: Int){
        
        navigationFunction(num)
        
    }
    
    //draw previews
    func drawOnAppear(){
        onAppearPreviewFunction(&pointsPreview)
    }
    
    
    
    
    
    
    
    
    func drawView(num:Int) -> some View {
        ZStack {
            DrawShape(pointsPreviewArray: pointsPreview, num: num)
            
                .stroke(lineWidth: 5)
                .foregroundColor(.black)
                .scaleEffect(CGSize(width: 0.5 ,height: 0.5 ))
                .padding()
                .background(Rectangle()
                                .foregroundColor(Color.yellow))
            
        }
    }
    
    
    
    struct DrawShape: Shape {
        
        var pointsPreviewArray: Array<[[CGPoint]]>
        var num: Int
        
        func path(in rect: CGRect) -> Path {
            
            
            return pathVarPreview[num]
            
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
                        Spacer()
                        //back to first view
                        NavigationLink(destination: ContentView()) {
                            
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            presentationMode.wrappedValue.dismiss()
                            
                        })
                        Spacer()
                        drawView
                        Spacer()
                        hButtons
                        
                        
                        
                        
                        
                    }.background(Color(.yellow))
                }
                else {
                    
                    HStack{//1
                        Spacer()
                        NavigationLink(destination: ContentView()) {
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            
                            presentationMode.wrappedValue.dismiss()
                            
                        })
                        Spacer()
                        
                        drawView
                        Spacer()
                        
                        vButtons
                        
                        
                    }.background(Color(.yellow))
                    
                    
                }
                
            }
            
            
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
        
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
                    endDrawFunction(&points)
                }))
            DrawShape(points: points)
            
                .stroke(lineWidth: 5)
                .foregroundColor(.black)
                .aspectRatio(1.0, contentMode: .fit)
        }//2
        
        
    }
    
    var hButtons: some View {
        HStack{
            Button(action: {clearButton()}){
                
                Image(systemName: "trash.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            Button(action: {continuousLine()}){
                
                Image(systemName: "pencil.and.outline")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(colorContinuous)
            }
            
            Button(action: {backButton()}){
                
                Image(systemName: "delete.backward")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            
            Button(action: {
                Writer.actionSheet()
            }) {
                Image(systemName: "square.and.arrow.up.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            
        }
        .background(Color(red: 0, green: 0.8, blue: 0.8))
        .foregroundColor(Color.black)
        
    }
    
    
    var vButtons: some View {
        VStack{
            Button(action: {clearButton()}){
                
                Image(systemName: "trash.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            Button(action: {continuousLine()}){
                
                Image(systemName: "pencil.and.outline")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(colorContinuous)
                
            }
            
            Button(action: {backButton()}){
                
                Image(systemName: "delete.backward")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            
            Button(action: {
                Writer.actionSheet()
            }) {
                Image(systemName: "square.and.arrow.up.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                
            }
            
            
        }
        .background(Color(red: 0, green: 0.8, blue: 0.8))
        .foregroundColor(Color.black)
    }
    
    
    
    
    
    //draw saved image when view appears
    func drawOnAppear(){
        
        onAppearDrawFunction(&points)
        
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
    
    
    
    
    
    //buttons
    func continuousLine(){
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













