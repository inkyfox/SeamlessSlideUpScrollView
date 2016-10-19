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
    func verticalDragged(origin: CGPoint, moved: CGSize)
    func verticalDragCancelled()
    func verticalDragFinished(origin: CGPoint, moved: CGSize, lastMove: CGSize, duration: TimeInterval)
}

class VerticalDragGestureRecognizer: UIGestureRecognizer {
    
    var touchSlop: CGFloat = 20 {  didSet { touchSlopSquare = touchSlop * touchSlop } }

    fileprivate var touchSlopSquare: CGFloat = 20 * 20

    var dragEnabled: Bool = true
    var targetSubview: UIView? = nil
    
    var dragDelegate: VerticalDragGestureRecognizerDelegate? = nil
    
    fileprivate var firstTouch: CGPoint = CGPoint.zero
    fileprivate var dragging: Bool = false
    fileprivate var prevMoved: CGSize = CGSize.zero
    fileprivate var prevTimestamp: TimeInterval = 0
    fileprivate var lastMove: CGSize = CGSize.zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .possible
        
        if touches.count != 1 || !dragEnabled {
            self.state = .cancelled
            return
        }
        
        let touch = touches.first!

        let point = touch.location(in: self.view)

        if let targetSubview = self.targetSubview , !targetSubview.frame.contains(point) {
            self.state = .cancelled
            return
        }
        
        dragging = false
        firstTouch = point
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if touches.count != 1 || !dragEnabled {
            dragDidCancel()
        } else if let touch = touches.first {
            let curPoint = touch.location(in: self.view)
            let movedX = (curPoint.x - firstTouch.x)
            let movedY = (curPoint.y - firstTouch.y)
            
            if dragging {
                dragDidChange(CGSize(width: movedX, height: movedY))
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        
        if dragging {
            if let touch = touches.first {
                let curPoint = touch.location(in: self.view)
                let movedX = (curPoint.x - firstTouch.x)
                let movedY = (curPoint.y - firstTouch.y)
                
                dragDidFinish(CGSize(width: movedX, height: movedY))
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
    
    fileprivate func dragDidBegin(_ origin: CGPoint) {
        self.state = .began
        dragging = true
        firstTouch = origin
        prevMoved = CGSize.zero
        prevTimestamp = Date().timeIntervalSince1970
        dragDelegate?.verticarDragBegan()
    }
    
    fileprivate func dragDidChange(_ moved: CGSize) {
        if dragging {
            self.state = .changed
            lastMove = CGSize(width: moved.width - prevMoved.width, height: moved.height - prevMoved.height)
            prevMoved = moved
            prevTimestamp = Date().timeIntervalSince1970
            
            dragDelegate?.verticalDragged(origin: firstTouch, moved: moved)
        }
    }
    
    fileprivate func dragDidCancel() {
        self.state = .cancelled
        
        if dragging {
            dragDelegate?.verticalDragCancelled()
            dragging = false
        }
    }
    
    fileprivate func dragDidFinish(_ moved: CGSize) {
        self.state = .ended
        
        if dragging {
            dragDelegate?.verticalDragFinished(origin: firstTouch,
                                               moved: moved,
                                               lastMove: lastMove,
                                               duration: Date().timeIntervalSince1970 - prevTimestamp)
            dragging = false
        }
    }
    
}


