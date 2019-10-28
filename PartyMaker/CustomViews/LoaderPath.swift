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
        bezierPath.move(to: CGPoint(x: 3, y: 3))
        bezierPath.addLine(to: CGPoint(x: 139, y: 3))
        bezierPath.addLine(to: CGPoint(x: 81.5, y: 43.7))
        bezierPath.addLine(to: CGPoint(x: 81, y: 139))
        bezierPath.addLine(to: CGPoint(x: 113, y: 155))
        bezierPath.addLine(to: CGPoint(x: 32, y: 155))
        bezierPath.addLine(to: CGPoint(x: 64.7, y: 138.99))
        bezierPath.addLine(to: CGPoint(x: 64.7, y: 43.7))
        bezierPath.addLine(to: CGPoint(x: 3, y: 3))
        bezierPath.close()
        UIColor.black.setStroke()
        bezierPath.lineWidth = 5.5
        bezierPath.lineJoinStyle = .round
        bezierPath.stroke()
        
        return bezierPath.cgPath
    }
}
