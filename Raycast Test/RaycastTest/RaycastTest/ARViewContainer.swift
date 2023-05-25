import SwiftUI
import RealityKit

struct ARViewContainer: UIViewControllerRepresentable {

//    func makeUIViewController(context: Context) -> some ViewController {
//        let vc = ViewController()
//        return vc
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//
//    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = ViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }

}


//
//#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//#endif

