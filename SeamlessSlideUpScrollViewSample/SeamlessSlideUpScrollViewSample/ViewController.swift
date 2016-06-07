//
//  ViewController.swift
//  SeamlessSlideUpScrollViewSample
//
//  Created by indy on 2016. 6. 7..
//  Copyright © 2016년 Gen X Hippies Company. All rights reserved.
//

import UIKit
import SeamlessSlideUpScrollView

class ViewController: UIViewController {

    @IBOutlet weak var slideUpView: SeamlessSlideUpView!
    @IBOutlet var tableView: SeamlessSlideUpTableView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var bgBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slideUpView.scrollView = tableView
        slideUpView.delegate = self
        
        tableView.dataSource = self
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleSlideUpView(sender: AnyObject) {
        
        if self.slideUpView.hidden {
            self.slideUpView.show(expandFull: false)
            self.button.setTitle("Slide Down", forState: .Normal)
        } else {
            self.slideUpView.hide()
            self.button.setTitle("Slide Up", forState: .Normal)
        }
    }
}

extension ViewController: SeamlessSlideUpViewDelegate {
    
    func slideUpViewWillAppear(slideUpView: SeamlessSlideUpView, height: CGFloat) {
        print("will appear \(height)")
        self.bgBottomConstraint.constant = height
        UIView.animateWithDuration(0.3) { [weak self] in self?.view.layoutIfNeeded() }
        self.button.setTitle("Slide Down", forState: .Normal)
    }
    
    func slideUpViewDidAppear(slideUpView: SeamlessSlideUpView, height: CGFloat) {
        print("did appear \(height)")
    }
    
    func slideUpViewWillDisappear(slideUpView: SeamlessSlideUpView) {
        print("will disappear")
        self.bgBottomConstraint.constant = 0
        UIView.animateWithDuration(0.3) { [weak self] in self?.view.layoutIfNeeded() }
        self.button.setTitle("Slide Up", forState: .Normal)
    }

    func slideUpViewDidDisappear(slideUpView: SeamlessSlideUpView) {
        print("did disappear")
    }
    
    func slideUpViewDidDrag(slideUpView: SeamlessSlideUpView, height: CGFloat) {
        print("did drag \(height)")

        self.bgBottomConstraint.constant = min(height, self.slideUpView.bounds.height - self.slideUpView.topWindowHeight)
        self.view.layoutIfNeeded()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        guard let label = cell.viewWithTag(1) as? UILabel else {
            return UITableViewCell()
        }
        
        label.text = "\(indexPath.row): Table row"
        
        return cell
    }
    
}