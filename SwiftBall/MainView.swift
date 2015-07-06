//
//  MainView.swift
//  SwiftBall
//
//  Created by John Henckel on 6/29/15.
//  Copyright (c) 2015 John Henckel. All rights reserved.
//

import UIKit

class MainView: UIView {
    
    var link: CADisplayLink!
    var balls = [Ball]()
    var size = UIScreen.mainScreen().bounds
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup()
    {
        for i in 1 ... 100 {
            balls.append(Ball().rand(size))
        }
        start()
    }
    
    func start() {
        link = CADisplayLink(target: self, selector: Selector("trigger"))
        link.frameInterval = 1
        link.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func stop() {
        link.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        link = nil
    }
    
    func trigger()
    {
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()
        
        // First time initialization
        if link == nil {
            setup()
        }
        
        for b in balls { b.draw(context) }
        
        for b in balls { b.integrate() }
        
        // collision with walls
        
        for b in balls { b.inbox(size) }
        
        // test all pairs for collision
        
        var hit = false
        
        if balls.count > 1 {
            for i in 0 ... balls.count - 2 {
                for j in i + 1 ... balls.count - 1 {
                    hit = balls[i].collide(balls[j]) || hit
                }
            }
        }
        
        if hit {
            // play a sound?
        }
    }

}
