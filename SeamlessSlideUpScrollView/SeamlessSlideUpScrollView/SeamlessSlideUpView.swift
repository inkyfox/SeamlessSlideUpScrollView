//
//  SeamlessSlideUpView.swift
//  SeamlessSlideUpScrollView
//
//  Created by indy on 2016. 6. 7..
//  Copyright © 2016년 Gen X Hippies Company. All rights reserved.
//

import UIKit

public class SeamlessSlideUpView: UIView {
    
    @IBOutlet weak public var tableView: SeamlessSlideUpTableView? = nil {
        didSet { self.targetView = tableView as? SeamlessSlideUpScrollViewType }
    }
    
    @IBOutlet public var delegate: SeamlessSlideUpViewDelegate? = nil

    @IBInspectable public var topWindowHeight: CGFloat = 60
    
    private weak var targetView: SeamlessSlideUpScrollViewType? = nil {
        didSet { self.setupScrollView() }
    }
    
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
        guard let targetView = self.targetView else { return }

        targetView.pauseScroll = true
        
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
        guard self.targetView != nil else { return }

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
        guard let targetView = self.targetView else { return }
        guard let view = self.targetView as? UIView else { return }
        
        view.removeFromSuperview()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: [], metrics: nil , views: ["scrollView": view]))

        let topConstraint = NSLayoutConstraint(item: targetView, attribute: NSLayoutAttribute.Top,
                                                relatedBy: NSLayoutRelation.Equal,
                                                toItem: self, attribute: NSLayoutAttribute.Top,
                                                multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: targetView, attribute: NSLayoutAttribute.Bottom,
                                                  relatedBy: NSLayoutRelation.Equal,
                                                  toItem: self, attribute: NSLayoutAttribute.Bottom,
                                                  multiplier: 1, constant: 0)
        self.addConstraints([topConstraint, bottomConstraint])

        self.topConstraint = topConstraint
        self.dragGestureRecognizer.targetSubview = view
        
        targetView.contentOffsetYChangedCallback = { [weak self] offsetY in
            if offsetY < -40 {
                self?.show(expandFull: false)
            }
        }
    }
    
    override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let subview = super.hitTest(point, withEvent: event)
        return subview !== self ? subview : nil
    }
    
    private func moveScrollView(amount: CGFloat) {
        guard let targetView = self.targetView else { return }

        let y = dragOriginY + amount
        if y <= 0 {
            if self.scrollViewPosition != 0 {
                self.topConstraint.constant = 0
                targetView.layoutSuperviewIfNeeded()
            }
            targetView.pauseScroll = false
        } else {
            targetView.pauseScroll = true
            self.topConstraint.constant = max(0, y)
            targetView.layoutSuperviewIfNeeded()
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
        guard let targetView = self.targetView else { return }

        let y = self.scrollViewPosition - targetView.contentOffset.y
        targetView.resetScrollTranslation()
        
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
        guard let targetView = self.targetView else { return }
        self.dragOriginY = self.scrollViewPosition - targetView.contentOffset.y
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
