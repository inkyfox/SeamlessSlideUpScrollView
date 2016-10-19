//
//  SeamlessSlideUpViewDelegate.swift
//  SeamlessSlideUpScrollView
//
//  Created by indy on 2016. 6. 8..
//  Copyright © 2016년 Gen X Hippies Company. All rights reserved.
//

import UIKit

@objc public protocol SeamlessSlideUpViewDelegate {

    optional func slideUpViewWillAppear(slideUpView: SeamlessSlideUpView, height: CGFloat)
    optional func slideUpViewDidAppear(slideUpView: SeamlessSlideUpView, height: CGFloat)
    
    optional func slideUpViewWillDisappear(slideUpView: SeamlessSlideUpView)
    optional func slideUpViewDidDisappear(slideUpView: SeamlessSlideUpView)
    
    optional func slideUpViewDidDrag(slideUpView: SeamlessSlideUpView, height: CGFloat)
}


