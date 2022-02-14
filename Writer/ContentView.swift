

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
//                        Spacer()
//                            .frame(width: 50)
                        //refresh previews
                        /*
                        Button(action:{
                            
                            refreshButton()
                            
                        }){
                            Image(systemName: "gobackward")
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                        }
                         */
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
                    //
                    
                    drawOnAppear()
                    print(items)//
                    
                })
               
                
                
        }
        

    }
    
    func addItem() {
        
           
            
            let newItem = Point(context: viewContext)
        newItem.points = [[]]
        print(newItem.points)
        
        
            /*
             items![index].points
             */

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            
        }
        print(items)
        maxViewNum = items.count
        saveNum(maxViewNum, KeyForUserDefaults: keyMaxViewNum)
        pathVarPreview.append(Path())
    }
    
    

    func deleteItem(_ num: Int){
        let itemToDelete = items[num]
        
            viewContext.delete(itemToDelete)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        maxViewNum = items.count
        saveNum(maxViewNum, KeyForUserDefaults: keyMaxViewNum)
        pathVarPreview.remove(at: num)
    }
    
    
    func navigationButton(_ num:Int){
        
//        }
        currentViewNum = num
        navigationFunction(points: points)
    }
    
    
    func drawOnAppear(){
        var pointsAppear:[[[CGPoint]]] = []
        print(items)
        print("???")
        print(items.count)
        for number in 0..<items.count{
            pointsAppear.insert((items[number].points), at: number)
        }
        
        print("appear")
        print(pointsAppear)
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
//            Color(.yellow)
//                .ignoresSafeArea()
            
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
//            .padding(.bottom, 5)
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
            
    //        print(points)
            
        }
        editItem(points)
    }
    
    
    //draw saved image when view appears
    func drawOnAppear(){
        /*
        for number in 0..<items.count{
            points.insert((items[number].points), at: number)
        }
         */
        points = []
//        for number in 0..<items.count{
            points = items[currentViewNum].points
        print(points)
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
//        clearFunction(&points[currentViewNum])
        
    }
    
    
    func backButton(){
        backFunction(&points)
        }//backButton
        
    func clearFunction(_ points: inout [[CGPoint]]){
        points = [[]]
        pathVar = Path()
        editItem(points)
        currentLayer = 0
    }


    func backFunction(_ points: inout [[CGPoint]]){
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
                editItem(points)
                currentLayer = 0
            } else {
                currentLayer = points.count - 1
                for currentNum in 0...currentLayer{
                    let firstPoint = points[currentNum].first
                    
                    
                    pathVar.move(to: firstPoint!)
                    for pointIndex in 1..<points[currentNum].count{
                        
                        pathVar.addLine(to: points[currentNum][pointIndex])
                        
                    }
                    
                    editItem(points)
                }
                
            }
            
            
            
            points.append([])
            currentLayer = points.count - 1
            
            
        } else{
            points = [[]]
            pathVar = Path()
            editItem(points)
            currentLayer = 0
    }
    }

    
        
    func editItem(_ pointsReceived: [[CGPoint]]) {
        
//            currentViewNum = loadNum(KeyForUserDefaults: keyCurrentViewNum)
            print(currentViewNum)
        
//        print(points)
        print("!!")
        print(pointsReceived)
//        print(points.count)
//        print(points[currentViewNum])
        
        let newItem = items[currentViewNum]
            newItem.points = pointsReceived
//

            do {
                try viewContext.save()
//
               
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        
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









