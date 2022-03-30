

import SwiftUI
import UIKit




let buttonColor = Color(red: 0.30, green: 0.65, blue: 0.70)
let drawColor = Color(red: 0.87, green: 0.68, blue: 0.12)
let backColor = Color(red: 0.92, green: 0.82, blue: 0.51)

var currentViewNum:Int = 0


struct ContentView: View {
        
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Point>
    
    
    @State var maxViewNum:Int = Defaults().loadNum(KeyForUserDefaults: keyMaxViewNum)
    
    
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
        
        
        Buttons().addFunction()
        
        
        maxViewNum = items.count
        Defaults().saveNum(maxViewNum, KeyForUserDefaults: keyMaxViewNum)
        
    }
    
    
    
    func deleteItem(_ num: Int){
        print(items)
        let itemToDelete = items[num]
        viewContext.delete(itemToDelete)
        
        
        Buttons().deleteFunction(num)
        
        maxViewNum = items.count
        Defaults().saveNum(maxViewNum, KeyForUserDefaults: keyMaxViewNum)
        print(items)
        
    }
    
    
    func navigationButton(_ num:Int){
        
        currentViewNum = num
        Appear().navigationFunction(points: points)
    }
    
    
    func drawOnAppear(){
        var pointsAppear:[[[CGPoint]]] = []
        
        for number in 0..<items.count{
            pointsAppear.insert((items[number].points), at: number)
        }
        
       
        Appear().onAppearPreviewFunction(pointsAppear)
        
        
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
















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }}









