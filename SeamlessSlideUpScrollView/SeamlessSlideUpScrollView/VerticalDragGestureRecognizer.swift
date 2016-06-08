//
//  VerticalDragGestureRecognizer.swift
//  SeamlessSlideUpScrollView
//
//  Created by indy on 2016. 6. 8..
//  Copyright © 2016년 Gen X Hippies Company. All rights reserved.
//

import UIKit

import UIKit.UIGestureRecognizerSubclass

protocol VerticalDragGestureRecognizerDelegate {
    func verticarDragBegan()
    func verticalDragged(origin origin: CGPoint, moved: CGSize)
    func verticalDragCancelled()
    func verticalDragFinished(origin origin: CGPoint, moved: CGSize, lastMove: CGSize, duration: NSTimeInterval)
}

class VerticalDragGestureRecognizer: UIGestureRecognizer {
    
    var touchSlop: CGFloat = 20 {  didSet { touchSlopSquare = touchSlop * touchSlop } }

    private var touchSlopSquare: CGFloat = 20 * 20

    var dragEnabled: Bool = true
    var targetSubview: UIView? = nil
    
    var dragDelegate: VerticalDragGestureRecognizerDelegate? = nil
    
    private var firstTouch: CGPoint = CGPointZero
    private var dragging: Bool = false
    private var prevMoved: CGSize = CGSizeZero
    private var prevTimestamp: NSTimeInterval = 0
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        self.state = .Possible
        
        if touches.count != 1 || !dragEnabled {
            self.state = .Cancelled
            return
        }
        
        let touch = touches.first!

        let point = touch.locationInView(self.view)

        if let targetSubview = self.targetSubview where !targetSubview.frame.contains(point) {
            self.state = .Cancelled
            return
        }
        
        dragging = false
        firstTouch = point
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        
        if touches.count != 1 || !dragEnabled {
            dragDidCancel()
        } else if let touch = touches.first {
            let curPoint = touch.locationInView(self.view)
            let movedX = (curPoint.x - firstTouch.x)
            let movedY = (curPoint.y - firstTouch.y)
            
            if dragging {
                dragDidChange(CGSizeMake(movedX, movedY))
            } else {
                let distanceX = abs(movedX)
                let distanceY = abs(movedY)
                
                let distanceSquare = distanceX * distanceX + distanceY * distanceY
                if !dragging && distanceSquare > self.touchSlopSquare {
                    if distanceX < distanceY {
                        dragDidBegin(curPoint)
                    } else {
                        dragDidCancel()
                    }
                }
            }
        } else {
            dragDidCancel()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        if dragging {
            if let touch = touches.first {
                let curPoint = touch.locationInView(self.view)
                let movedX = (curPoint.x - firstTouch.x)
                let movedY = (curPoint.y - firstTouch.y)
                
                dragDidFinish(CGSizeMake(movedX, movedY))
            } else {
                dragDidCancel()
            }
        } else {
            dragDidCancel()
        }
    }
    
}

// MARK: - Process state changes

extension VerticalDragGestureRecognizer {
    
    private func dragDidBegin(origin: CGPoint) {
        self.state = .Began
        dragging = true
        firstTouch = origin
        prevMoved = CGSizeZero
        prevTimestamp = NSDate().timeIntervalSince1970
        dragDelegate?.verticarDragBegan()
    }
    
    private func dragDidChange(moved: CGSize) {
        if dragging {
            self.state = .Changed
            
            prevMoved = moved
            prevTimestamp = NSDate().timeIntervalSince1970
            
            dragDelegate?.verticalDragged(origin: firstTouch, moved: moved)
        }
    }
    
    private func dragDidCancel() {
        self.state = .Cancelled
        
        if dragging {
            dragDelegate?.verticalDragCancelled()
            dragging = false
        }
    }
    
    private func dragDidFinish(moved: CGSize) {
        self.state = .Ended
        
        if dragging {
            dragDelegate?.verticalDragFinished(origin: firstTouch,
                                               moved: moved,
                                               lastMove: CGSizeMake(moved.width - prevMoved.width, moved.height - prevMoved.height),
                                               duration: NSDate().timeIntervalSince1970 - prevTimestamp)
            dragging = false
        }
    }
    
}


