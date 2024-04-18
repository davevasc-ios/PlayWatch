//
//  TabShape.swift
//  PlayWatch
//
//  Created by David on 15/4/24.
//

import SwiftUI

struct TabShape: Shape {
    var midpoint: CGFloat
    
    var animatableData: CGFloat {
        get { midpoint }
        set {
            midpoint = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            let height: Double = 12.0
            let horizontal: Double = 55
            let rad: Double = height / 2
            
            path.addPath(Rectangle().path(in: rect))
            
            path.move(to: .init(x: midpoint - horizontal, y: 0))
            
            let to = CGPoint(x: midpoint, y: -height)
            let control1 = CGPoint(x: midpoint - height - rad, y: 0)
            let control2 = CGPoint(x: midpoint - height - rad, y: -height)
            path.addCurve(to: to, control1: control1, control2: control2)
            
            let to1 = CGPoint(x: midpoint + horizontal, y: 0)
            let control3 = CGPoint(x: midpoint + height + rad, y: -height)
            let control4 = CGPoint(x: midpoint + height + rad, y: 0)
            path.addCurve(to: to1, control1: control3, control2: control4)
            
        }
    }
}

#Preview {
    TabBarView()
}
