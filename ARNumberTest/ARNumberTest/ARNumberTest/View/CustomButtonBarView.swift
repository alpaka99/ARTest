//
//  CustomButtonBarView.swift
//  ARNumberTest
//
//  Created by user on 2023/05/03.
//

import SwiftUI

struct CustomButtonBarView: View {
    
    var count: Count
    
    var body: some View {
        HStack (alignment: .center, spacing: 50) {
            Button { // decrement
                count.num -= 1
                print("Tap -- : \(count.num)")
            } label: {
                Image(systemName: "minus.diamond")
            }
            
            
            Button { // initialize
                count.num = 0
                print("Tap    : \(count.num)")
            } label: {
                Image(systemName: "xmark.diamond.fill")
            }
            
            Button { // increment
                count.num += 1
                print("Tap ++ : \(count.num)")
            } label: {
                Image(systemName: "plus.diamond")
            }
            
//            Button { // turn camera button
//
//            } label: {
//                Image(systemName: <#T##String#>)
//            }
        }
        .padding(.bottom, 15)
        .font(.system(size: 32))
        .foregroundColor(.white)
        .frame(width: UIScreen.main.bounds.width, height: 80, alignment: .center)
        .background(Color.black)
        .opacity(0.87)
    }
}

//struct CustomButtonBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomButtonBarView()
//    }
//}
