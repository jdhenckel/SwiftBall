//
//  Ball.swift
//  SwiftBall
//
//  Created by John Henckel on 7/3/15.
//  Copyright (c) 2015 John Henckel. All vs reserved.
//

import Foundation
import UIKit

//------------------------------------------------------------------------------
struct Vec2 {
    var x:CGFloat = 0
    var y:CGFloat = 0
}

func + (u: Vec2, v: Vec2) -> Vec2 {
    return Vec2(x: u.x + v.x, y: u.y + v.y)
}

func - (u: Vec2, v: Vec2) -> Vec2 {
    return Vec2(x: u.x - v.x, y: u.y - v.y)
}

func * (u: Vec2, a: CGFloat) -> Vec2 {
    return Vec2(x: u.x * a, y: u.y * a)
}

func len2(a: Vec2) -> CGFloat {
    return a.x * a.x + a.y * a.y
}

func len(a: Vec2) -> CGFloat {
    return sqrt(len2(a))
}

func dist2(u: Vec2, v: Vec2) -> CGFloat {
    return len2(u - v)
}

func dist(u: Vec2, v: Vec2) -> CGFloat {
    return len(u - v)
}

func maxnorm(a: Vec2) -> CGFloat {
    return max(a.x, a.y)
}

func dot(u: Vec2, v: Vec2) -> CGFloat {
    return u.x * v.x + u.y * v.y
}
//------------------------------------------------------------------------------
class Ball {
    var pos:Vec2
    var vel:Vec2
    var r:CGFloat
    
    init() {
        pos = Vec2()
        vel = Vec2()
        r = 10
    }
    
    init(x:CGFloat, y:CGFloat, vx:CGFloat, vy:CGFloat) {
        pos = Vec2(x: x, y: y)
        vel = Vec2(x: vx, y: vy)
        r = 10
    }
    
    func rand(size:CGRect) -> Ball {
        pos = Vec2(x: CGFloat(arc4random_uniform(UInt32(size.width))), y: CGFloat(arc4random_uniform(UInt32(size.height))))
        vel = Vec2(x: CGFloat(arc4random_uniform(UInt32(10)))-5, y: CGFloat(arc4random_uniform(UInt32(10)))-5)
        return self
    }
    
    func integrate() {
        pos = pos + vel
    }
    
    func inbox(size:CGRect){
        if pos.x + r > size.width && vel.x > 0 || pos.x - r < 0 && vel.x < 0 { vel.x = -vel.x }
        if pos.y + r > size.height && vel.y > 0 || pos.y - r < 0 && vel.y < 0 { vel.y = -vel.y }
    }
    
    func draw(c:CGContext) {
        let rr = CGRect(x: pos.x - r, y: pos.y - r, width: 2*r, height: 2*r)
        CGContextFillEllipseInRect(c, rr)
    }
    
    func collide(b:Ball) -> Bool {
        let rr = r + b.r
        let d = pos - b.pos
        if maxnorm(d) < rr {
            let d2 = len2(d)
            if d2 < rr * rr {
                let k = dot(d, vel - b.vel)
                if k < 0 {
                    let dv = d * (k / d2)
                    vel = vel - dv
                    b.vel = b.vel + dv
                    return true
                }
            }
        }
        return false
    }
}


