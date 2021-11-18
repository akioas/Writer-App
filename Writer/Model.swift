import SwiftUI
import UIKit



struct PreviewImage{
    func path()->(URL){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)


        
       
        let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        var fileName = String(currentViewNum)
        return path.appendingPathComponent(fileName).appendingPathExtension("jpg")
    
    
    }
    
    
    
    func savePreviewImage(){
        let fileURL = path()
        print(fileURL)
        let image = FirstView().drawView.saveImage(size: imageSize).jpegData(
            compressionQuality: 1)

        do {
            let result = try image?.write(to: fileURL, options: .atomic)
        } catch let error {
            print(error)
        }
    }


}





extension UIView {
    func saveImage() -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
//        format.opaque = false
        return UIGraphicsImageRenderer(size: self.layer.frame.size, format: format).image { context in
            
            self.drawHierarchy(in: self.layer.bounds, afterScreenUpdates: true)
        }
    }
}
extension View {
    func saveImage(size: CGSize) -> UIImage {
        let yPoint = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        let originPoint = CGPoint(x: -10, y: -10 )
//        print(originPoint)
        let controller = UIHostingController(rootView: self)
        controller.view.bounds = CGRect(origin: originPoint, size: size)
        let image = controller.view.saveImage()
        return image
    }
}























/*
 struct RootView: View {
     @State private var number = 0

     var body: some View {
         VStack {
             Button(action: {
                 self.number += 1
             }) {
                 Text("Tap to create")
             }
             ForEach(0 ..< number, id: \.self) { _ in
                 MyRectView()
             }
         }
     }
 }
 */


