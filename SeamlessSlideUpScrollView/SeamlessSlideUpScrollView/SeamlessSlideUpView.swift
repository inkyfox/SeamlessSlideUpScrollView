//
//  SeamlessSlideUpView.swift
//  SeamlessSlideUpScrollView
//
//  Created by indy on 2016. 6. 7..
//  Copyright © 2016년 Gen X Hippies Company. All rights reserved.
//

import UIKit

public class SeamlessSlideUpView: UIView {
    
    @IBOutlet public var scrollView: SeamlessSlideUpScrollViewType? = nil {
        didSet { self.setupScrollView() }
    }
    
    @IBInspectable public var topWindowHeight: CGFloat = 60
    
    public var delegate: SeamlessSlideUpViewDelegate? = nil
    
    private var topConstraint: NSLayoutConstraint!
    private let dragGestureRecognizer = VerticalDragGestureRecognizer()
    private var dragOriginY: CGFloat = 0

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildLayout()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.buildLayout()
    }
    
    public func show(expandFull expandFull: Bool) {
        guard let scrollView = self.scrollView else { return }

        scrollView.pauseScroll = true
        
        let destination = expandFull ? 0 : topWindowHeight
        let scrollViewPosition = self.scrollViewPosition
        
        if destination == scrollViewPosition { return }
        
        let scrollViewHeight = self.bounds.height - destination

        if self.hidden {
            self.scrollViewPosition = self.bounds.height
            self.hidden = false
        }
        
        let showFromBottom = !expandFull && self.scrollViewPosition > destination
        
        if showFromBottom {
            delegate?.slideUpViewWillAppear?(self, height: scrollViewHeight)
        }
        
        let distanceFactor = Double(abs(scrollViewPosition - destination) / self.bounds.height) / 2.0 + 0.5
        let duration: NSTimeInterval = 0.3 * distanceFactor
        UIView.animateWithDuration(duration,
                                   delay: 0,
                                   options: .CurveEaseOut,
                                   animations: { [weak self] in self?.scrollViewPosition = destination },
                                   completion: { [weak self] _ in if showFromBottom, let sself = self { sself.delegate?.slideUpViewDidAppear?(sself, height: scrollViewHeight) } }
        )
    }
    
    public func hide() {
        guard self.scrollView != nil else { return }

        if self.hidden { return }
        
        delegate?.slideUpViewWillDisappear?(self)

        
        let destination = self.bounds.height
        let distanceFactor = Double(abs(scrollViewPosition - destination) / self.bounds.height) / 2.0 + 0.5
        let duration: NSTimeInterval = 0.3 * distanceFactor
        UIView.animateWithDuration(duration,
                                   delay: 0,
                                   options: .CurveEaseOut,
                                   animations: { [weak self] in self?.scrollViewPosition = destination },
                                   completion: { [weak self] _ in if let sself = self {
                                        sself.hidden = true
                                        sself.delegate?.slideUpViewDidDisappear?(sself)
                                    } }
        )
    }
}

extension SeamlessSlideUpView {
    
    private func buildLayout() {
        self.hidden = true
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = true
        
        self.dragGestureRecognizer.delegate = self
        self.dragGestureRecognizer.dragDelegate = self
        self.addGestureRecognizer(dragGestureRecognizer)
        
        self.setupScrollView()
    }

    private func setupScrollView() {
        guard let scrollView = self.scrollView as? UIView else { return }
        
        scrollView.removeFromSuperview()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: [], metrics: nil , views: ["scrollView": scrollView]))

        let topConstraint = NSLayoutConstraint(item: scrollView, attribute: NSLayoutAttribute.Top,
                                                relatedBy: NSLayoutRelation.Equal,
                                                toItem: self, attribute: NSLayoutAttribute.Top,
                                                multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: scrollView, attribute: NSLayoutAttribute.Bottom,
                                                  relatedBy: NSLayoutRelation.Equal,
                                                  toItem: self, attribute: NSLayoutAttribute.Bottom,
                                                  multiplier: 1, constant: 0)
        self.addConstraints([topConstraint, bottomConstraint])
        
        self.topConstraint = topConstraint
        self.dragGestureRecognizer.targetSubview = scrollView
    }
    
    override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let subview = super.hitTest(point, withEvent: event)
        return subview !== self ? subview : nil
    }
    
    private func moveScrollView(amount: CGFloat) {
        guard let scrollView = self.scrollView else { return }

        let y = dragOriginY + amount
        if y <= 0 {
            if self.scrollViewPosition != 0 {
                self.topConstraint.constant = 0
                scrollView.layoutSuperviewIfNeeded()
            }
            scrollView.pauseScroll = false
        } else {
            scrollView.pauseScroll = true
            self.topConstraint.constant = max(0, y)
            scrollView.layoutSuperviewIfNeeded()
        }
        
        delegate?.slideUpViewDidDrag?(self, height: self.bounds.height - self.topConstraint.constant)
    }
    
    private var scrollViewPosition: CGFloat {
        get { return self.topConstraint.constant }
        set {
            self.topConstraint.constant = newValue
            self.layoutIfNeeded()
        }
    }
    
    private func restoreScrollViewPosition(velocity velocity: CGFloat = 0) {
        guard let scrollView = self.scrollView else { return }

        let y = self.scrollViewPosition - scrollView.contentOffset.y
        scrollView.resetScrollTranslation()
        
        if y <= 0 {
            return
        } else if y < topWindowHeight {
            if velocity >= 0 {
                show(expandFull: false)
            } else {
                show(expandFull: true)
            }
        } else {
            if velocity >= 0 {
                hide()
            } else {
                show(expandFull: false)
            }
        }
    }

}

extension SeamlessSlideUpView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension SeamlessSlideUpView: VerticalDragGestureRecognizerDelegate {
    func verticarDragBegan() {
        guard let scrollView = self.scrollView else { return }
        self.dragOriginY = self.scrollViewPosition - scrollView.contentOffset.y
    }
    
    func verticalDragged(origin origin: CGPoint, moved: CGSize) {
        self.moveScrollView(moved.height)
    }
    
    func verticalDragCancelled() {
        self.restoreScrollViewPosition()
    }
    
    func verticalDragFinished(origin origin: CGPoint, moved: CGSize, lastMove: CGSize, duration: NSTimeInterval) {
        if duration == 0 {
            self.restoreScrollViewPosition()
        } else {
            self.restoreScrollViewPosition(velocity: lastMove.height / CGFloat(duration))
        }
    }
}
