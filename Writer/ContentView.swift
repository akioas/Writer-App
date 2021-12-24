
import SwiftUI
import UIKit




let buttonColor = Color(red: 0.30, green: 0.65, blue: 0.70)
let drawColor = Color(red: 0.87, green: 0.68, blue: 0.12)
let backColor = Color(red: 0.92, green: 0.82, blue: 0.51)


struct ContentView: View {
    
    
    @State var currentViewNum:Int = loadNum(KeyForUserDefaults: keyCurrentViewNum)
    @State var maxViewNum:Int = loadNum(KeyForUserDefaults: keyMaxViewNum)
    @State var points = loadPoints()
    @State var pointsPreview = loadPointsForPreview()
    @State private var timeElapsed = false
    
    var body: some View {
        ZStack{
 
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
                                                    .foregroundColor(drawColor))
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
                
                
                
                

            }
            
            
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
        maxViewNum = loadNum(KeyForUserDefaults: keyMaxViewNum)
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
                                .foregroundColor(drawColor))
            
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
                Writer.actionSheet()
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
                Writer.actionSheet()
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
    
    
    
    
    
    //draw saved image when view appears
    func drawOnAppear(){
        
        onAppearDrawFunction(&points)
        
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
        }//backButton
        
        
        
        
    
    
    struct DrawShape: Shape {
        
        var points: Array<[CGPoint]>
        
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
    }
    
    
    
    
}













