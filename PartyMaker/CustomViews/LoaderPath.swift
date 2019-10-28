//
//  LoaderPath.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/25/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
import UIKit

struct LoaderPath {
    static func glassPath() -> CGPath {
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 18, y: 16))
        bezierPath.addCurve(to: CGPoint(x: 3, y: 3), controlPoint1: CGPoint(x: 9.83, y: 10.64), controlPoint2: CGPoint(x: 3, y: 3))
        bezierPath.addLine(to: CGPoint(x: 38.5, y: 3))
        bezierPath.addLine(to: CGPoint(x: 75, y: 3))
        bezierPath.addCurve(to: CGPoint(x: 61, y: 16), controlPoint1: CGPoint(x: 75, y: 3), controlPoint2: CGPoint(x: 68.61, y: 10.64))
        bezierPath.addCurve(to: CGPoint(x: 44.56, y: 24.42), controlPoint1: CGPoint(x: 53.39, y: 21.36), controlPoint2: CGPoint(x: 44.56, y: 24.42))
        bezierPath.addLine(to: CGPoint(x: 44.29, y: 74.58))
        bezierPath.addLine(to: CGPoint(x: 61.24, y: 83))
        bezierPath.addLine(to: CGPoint(x: 18.35, y: 83))
        bezierPath.addLine(to: CGPoint(x: 35.67, y: 74.57))
        bezierPath.addLine(to: CGPoint(x: 35.67, y: 24.42))
        bezierPath.addCurve(to: CGPoint(x: 18, y: 16), controlPoint1: CGPoint(x: 35.67, y: 24.42), controlPoint2: CGPoint(x: 26.17, y: 21.36))
        bezierPath.close()
        UIColor.black.setStroke()
        bezierPath.lineWidth = 5.5
        bezierPath.lineJoinStyle = .round
        bezierPath.stroke()
        
        return bezierPath.cgPath
    }
}
