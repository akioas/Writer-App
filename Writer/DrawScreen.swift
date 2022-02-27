

import SwiftUI
import UIKit

//var count = 0

var points:[[CGPoint]] = []

struct FirstView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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
                            
//                            editItem(points)
                           
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
//                            editItem(points)
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
                    timeVar = !timeVar
                    /*
                    count = count + 1
                    if count > 10{
                        timeVar = !timeVar
                        count = 0
                    }
                     */
                    
                })
                            .onEnded( { _ in
                    
                    endDrawFunction(&points)
//                    editItem(points)
                    //                    points.append([])
                }))
            DrawShape(points: points, changed: timeVar)
//            DrawShape(points: points)
            
                .stroke(lineWidth: 5)
                .foregroundColor(.black)
                .aspectRatio(1.0, contentMode: .fit)
        }//2
        .onReceive(timer) { _ in
                        editItem(points)
            
          
        }
        
        
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
        
    }
    
    
    //draw saved image when view appears
    func drawOnAppear(){
        
        points = []
        points = items[currentViewNum].points
        
        onAppearDrawFunction(&points)
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50) ) {
//            print("edited")
//            timeVar = !timeVar
//        }
        
    }
    
    
    
    func addNewPoint(_ value: DragGesture.Value) {
        
        addNewPointFunction(&points, value: value)
        
        
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
        pathVar = UIBezierPath()
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
            
            
            
            return Path(pathFunction(points).cgPath)
            
        }
        
    }
    
}










