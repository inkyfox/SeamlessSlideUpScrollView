//
//  SeamlessSlideUpViewDelegate.swift
//  SeamlessSlideUpScrollView
//
//  Created by indy on 2016. 6. 8..
//  Copyright © 2016년 Gen X Hippies Company. All rights reserved.
//

import UIKit

@objc public protocol SeamlessSlideUpViewDelegate {

    @objc optional func slideUpViewWillAppear(_ slideUpView: SeamlessSlideUpView, height: CGFloat)
    @objc optional func slideUpViewDidAppear(_ slideUpView: SeamlessSlideUpView, height: CGFloat)
    
    @objc optional func slideUpViewWillDisappear(_ slideUpView: SeamlessSlideUpView)
    @objc optional func slideUpViewDidDisappear(_ slideUpView: SeamlessSlideUpView)
    
    @objc optional func slideUpViewDidDrag(_ slideUpView: SeamlessSlideUpView, height: CGFloat)
}


