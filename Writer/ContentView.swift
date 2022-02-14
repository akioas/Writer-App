

import SwiftUI
import UIKit




let buttonColor = Color(red: 0.30, green: 0.65, blue: 0.70)
let drawColor = Color(red: 0.87, green: 0.68, blue: 0.12)
let backColor = Color(red: 0.92, green: 0.82, blue: 0.51)

var currentViewNum:Int = 0


struct ContentView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Point>
    
    
    @State var maxViewNum:Int = loadNum(KeyForUserDefaults: keyMaxViewNum)
    
    
    var body: some View {
        ZStack{
            
            NavigationView {
                VStack{
                    HStack{
                        //new image
                        Button(action: {
                            addItem()
                            
                        }) {
                            
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        
                    }
                    Spacer()
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
                                                    .foregroundColor(drawColor))
                                
                            }
                            .simultaneousGesture(TapGesture().onEnded{
                                currentViewNum = num
                                self.navigationButton(currentViewNum)
                            })
                            ZStack{
                                Button(action:{
                                    deleteItem(num)
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
                
            }
            
            
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onAppear(perform: {
              
                drawOnAppear()
              
                
            })
            
            
            
        }
        
        
    }
    
    func addItem() {
        
        
        addFunction()
        
        
        maxViewNum = items.count
        saveNum(maxViewNum, KeyForUserDefaults: keyMaxViewNum)
        
    }
    
    
    
    func deleteItem(_ num: Int){
        let itemToDelete = items[num]
        viewContext.delete(itemToDelete)
        
        deleteFunction(num)
        maxViewNum = items.count
        saveNum(maxViewNum, KeyForUserDefaults: keyMaxViewNum)
        
        
    }
    
    
    func navigationButton(_ num:Int){
        
        currentViewNum = num
        navigationFunction(points: points)
    }
    
    
    func drawOnAppear(){
        var pointsAppear:[[[CGPoint]]] = []
        
        for number in 0..<items.count{
            pointsAppear.insert((items[number].points), at: number)
        }
        
       
        onAppearPreviewFunction(pointsAppear)
        
        
    }
    
    
    
    func drawView(num:Int) -> some View {
        ZStack {
            DrawShape(pointsPreviewArray: items, num: num)
            
                .stroke(lineWidth: 5)
                .foregroundColor(.black)
                .scaleEffect(CGSize(width: 0.5 ,height: 0.5 ))
                .padding()
                .background(Rectangle()
                                .foregroundColor(drawColor))
            
        }
    }
    
    
    
    struct DrawShape: Shape {
        
        var pointsPreviewArray: FetchedResults<Point>
        var num: Int
        
        func path(in rect: CGRect) -> Path {
            
            
            return pathVarPreview[num]
            
        }
        
    }
    
    
    
}





import SwiftUI
import UIKit

var points:[[CGPoint]] = []

struct FirstView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var timeVar = false
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Point>
    
    
    var body: some View {
        
        return ZStack {
         
            
            GeometryReader { proxy in
                if proxy.size.width < proxy.size.height {
                    VStack{//1
                        Spacer()
                        //back to first view
                        NavigationLink(destination: ContentView()) {
                            
                            Image(systemName: "arrow.left.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding()
                            
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            presentationMode.wrappedValue.dismiss()
                            
                        })
                        Spacer()
                        drawView
                        Spacer()
                        hButtons
                        Spacer()
                        
                        
                        
                        
                    }.background(backColor)
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
                        Spacer()
                        
                    }.background(backColor)
                    
                    
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
            
                .foregroundColor(drawColor)
                .aspectRatio(1.0, contentMode: .fit)
            
                .gesture(DragGesture().onChanged( {
                    
                    value in
                    self.addNewPoint(value)
                    
                })
                            .onEnded( { _ in
                    
                    endDrawFunction(&points)
                    //                    points.append([])
                }))
            DrawShape(points: points, changed: timeVar)
            
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
            .background(buttonColor)
           
            .cornerRadius(8)
            Button(action: {continuousLineButton()}){
                
                Image(systemName: "pencil.and.outline")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(colorContinuous)
            }
            .background(buttonColor)
            .cornerRadius(8)
            Button(action: {backButton()}){
                
                Image(systemName: "delete.backward")
                    .resizable()
                    .frame(width: 50, height: 50)
            }.background(buttonColor)
                .cornerRadius(8)
            
            
            Button(action: {
                actionSheetFunc()
            }) {
                Image(systemName: "square.and.arrow.up.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            .background(buttonColor)
            .cornerRadius(8)
            
        }
        
        .foregroundColor(Color.black)
        
    }
    
    
    var vButtons: some View {
        VStack{
            Button(action: {clearButton()}){
                
                Image(systemName: "trash.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            .background(buttonColor)
            .cornerRadius(8)
            Button(action: {continuousLineButton()}){
                
                Image(systemName: "pencil.and.outline")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(colorContinuous)
                
            }
            .background(buttonColor)
            .cornerRadius(8)
            Button(action: {backButton()}){
                
                Image(systemName: "delete.backward")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            .background(buttonColor)
            .cornerRadius(8)
            
            Button(action: {
                actionSheetFunc()
            }) {
                Image(systemName: "square.and.arrow.up.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                
            }
            .background(buttonColor)
            .cornerRadius(8)
            
        }
        
        .foregroundColor(Color.black)
    }
    
    
    func endDrawFunction(_ points: inout [[CGPoint]]){
        
        if drawMode == 1{
            currentLayer = currentLayer + 1
            
            points.append([])
           
            
        }
        editItem(points)
    }
    
    
    //draw saved image when view appears
    func drawOnAppear(){
        
        points = []
        points = items[currentViewNum].points
        
        onAppearDrawFunction(&points)
        
    }
    
    
    
    
    
    func addNewPoint(_ value: DragGesture.Value) {
        
        addNewPointFunction(&points, value: value)
        timeVar = !timeVar
        
    }
    
    
    
    
    
    //buttons
    func continuousLineButton(){
        
        continuousLineFunction(&points)
        
    }
    
    func clearButton(){
        
        clearFunction(&points)
 
        
    }
    
    
    func backButton(){
        backFunction(&points)
        editItem(points)
    }//backButton
    
    func clearFunction(_ points: inout [[CGPoint]]){
        points = [[]]
        pathVar = Path()
        editItem(points)
        currentLayer = 0
    }
    
    
    func editItem(_ pointsReceived: [[CGPoint]]) {
        
        
        let newItem = items[currentViewNum]
        newItem.points = pointsReceived
        
        
        editView()
        
    }
    
    
    
    
    
    struct DrawShape: Shape {
        
        var points: [[CGPoint]]
        var changed: Bool
        func path(in rect: CGRect) -> Path {
            
            
            
            return pathFunction(points)
            
        }
        
    }
    
}











struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }}









